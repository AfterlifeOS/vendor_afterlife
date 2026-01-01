#!/usr/bin/env python3
import json
import os
import argparse
import sys

def load_json(path):
    if not os.path.exists(path):
        return {"response": []}
    try:
        with open(path, 'r') as f:
            return json.load(f)
    except json.JSONDecodeError:
        print(f"Warning: {path} is not valid JSON. Starting fresh.")
        return {"response": []}

def save_json(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

def main():
    parser = argparse.ArgumentParser(description='Update OTA JSON with variant info.')
    parser.add_argument('--json_path', required=True, help='Path to the existing updates.json file (Input)')
    parser.add_argument('--output_path', help='Path to save the result JSON (Output). If not set, overwrites input.')
    parser.add_argument('--device', required=True, help='Device hardware codename (e.g. surya)')
    parser.add_argument('--rom_codename', required=True, help='ROM codename (e.g. serenity)')
    parser.add_argument('--maintainer', required=True, help='Maintainer name')
    parser.add_argument('--oem', required=True, help='OEM name')
    parser.add_argument('--version', required=True, help='Android/ROM Version')
    parser.add_argument('--buildtype', required=True, help='Build type (official, community, etc.)')
    parser.add_argument('--variant', required=True, help='Build variant (gapps, vanilla, etc.)')
    parser.add_argument('--filename', required=True, help='Zip filename')
    parser.add_argument('--download_url', required=True, help='Unified download URL')
    parser.add_argument('--timestamp', required=True, type=int, help='Build timestamp')
    parser.add_argument('--md5', required=True, help='MD5 checksum')
    parser.add_argument('--sha256', required=True, help='SHA256 checksum')
    parser.add_argument('--size', required=True, type=int, help='File size in bytes')
    parser.add_argument('--forum', default="", help='Forum URL')
    parser.add_argument('--telegram', default="", help='Telegram URL')

    args = parser.parse_args()

    # Load existing data (Master)
    data = load_json(args.json_path)
    
    # Find existing entry based on Device Hardware Code (e.g. surya)
    device_entry = None
    for entry in data.get("response", []):
        if entry.get("device_code") == args.device:
            device_entry = entry
            break
    
    # Fallback: If single entry exists (common for per-device file), adapt it
    if not device_entry and len(data.get("response", [])) == 1:
        print(f"Adapting existing entry for device: {args.device}")
        device_entry = data["response"][0]
        device_entry["device_code"] = args.device
    
    if not device_entry:
        device_entry = {
            "maintainer": args.maintainer,
            "oem": args.oem,
            "device": "Unknown Device", 
            "device_code": args.device, # Hardware Codename as ID
            "download": args.download_url,
            "forum": args.forum,
            "telegram": args.telegram,
            "variants": {}
        }
        data["response"].append(device_entry)
    
    # Update Unified Info
    device_entry["maintainer"] = args.maintainer
    device_entry["oem"] = args.oem
    device_entry["device_code"] = args.device
    device_entry["download"] = args.download_url
    device_entry["buildtype"] = args.buildtype
    
    if args.forum: device_entry["forum"] = args.forum
    if args.telegram: device_entry["telegram"] = args.telegram
    
    if device_entry.get("device") == "Unknown Device":
        device_entry["device"] = args.device

    # Ensure variants dict exists
    if "variants" not in device_entry:
        device_entry["variants"] = {}

    # Update Specific Variant Info
    device_entry["variants"][args.variant] = {
        "codename": args.rom_codename, # Moved inside variant
        "version": args.version,
        "filename": args.filename,
        "timestamp": args.timestamp,
        "md5": args.md5,
        "sha256": args.sha256,
        "size": args.size
    }

    # Cleanup Root Fields (Remove codename from root)
    fields_to_remove = ["filename", "md5", "sha256", "size", "timestamp", "version", "codename"]
    for field in fields_to_remove:
        if field in device_entry:
            del device_entry[field]

    # Reorder keys for human readability (Removed codename)
    ordered_keys = ["maintainer", "oem", "device", "device_code", "buildtype", "download", "forum", "telegram", "variants"]
    new_entry = {}
    
    # Add prioritized keys first
    for key in ordered_keys:
        if key in device_entry:
            new_entry[key] = device_entry[key]
    
    # Add remaining keys (if any)
    for key in device_entry:
        if key not in new_entry:
            new_entry[key] = device_entry[key]
            
    # Replace the old entry reference in the list with the new ordered dict
    # We need to find the index because we are replacing the object entirely
    try:
        idx = data["response"].index(device_entry)
        data["response"][idx] = new_entry
    except ValueError:
        # Should not happen, but safe fallback
        pass

    # Determine Output Path
    target_path = args.output_path if args.output_path else args.json_path
    
    # Ensure output directory exists
    target_dir = os.path.dirname(target_path)
    if target_dir and not os.path.exists(target_dir):
        os.makedirs(target_dir)

    save_json(target_path, data)
    print(f"Successfully updated {args.variant} info for {args.rom_codename} ({args.device}). Saved to {target_path}")

if __name__ == "__main__":
    main()
