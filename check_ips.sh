check_ips() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: check_ips <filename>"
        echo "Example: check_ips ips.txt"
        return 1
    fi

    local filename="$1"
    local output_file="alive_hosts.txt"

    if [ ! -f "$filename" ]; then
        echo "Error: File '$filename' not found."
        return 1
    fi

    local temp_file=$(mktemp)

    grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$filename" | while read ip; do
       ping -c1 -W1 "$ip" &> /dev/null; echo "$ip is alive" >> "$temp_file" &
        
    done
wait

mv "$temp_file" "$output_file"

echo "Scan complete. Live hosts saved to $output_file."
}