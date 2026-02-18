#!/bin/bash

record_file="bookStore.db"
temp_file="/tmp/bookstore.$$"

touch "$record_file"
trap 'rm -f "$temp_file"' EXIT

pause(){
    read -p "Press Enter to continue..."
}

confirm(){
    read -p "Are you sure? (y/n): " ans
    case "$ans" in
        y|Y|yes|YES) return 0;;
        *) echo "Cancelled"; return 1;;
    esac
}

menu(){
clear
echo "=============================="
echo "   BOOK STORE MANAGEMENT"
echo "=============================="
echo "1. Add Book"
echo "2. Search Book"
echo "3. Edit Book"
echo "4. Delete Book"
echo "5. View All Books"
echo "6. Exit"
echo "=============================="
read -p "Enter choice: " choice
}

add_book(){
echo "Enter Book Category:"
read category

echo "Enter Book Title:"
read title

echo "Enter Author Name:"
read author

echo "Enter Price:"
read price

echo "Enter Quantity:"
read qty

echo "Adding record..."
echo "$category,$title,$author,$price,$qty" >> "$record_file"
echo "✅ Book added successfully!"
pause
}

view_books(){
echo "===== Book List ====="
if [ ! -s "$record_file" ]; then
    echo "No records found."
else
    column -t -s, "$record_file"
fi
pause
}

search_book(){
read -p "Enter title to search: " search
grep -i "$search" "$record_file" > "$temp_file"

if [ ! -s "$temp_file" ]; then
    echo "No book found."
else
    echo "Found:"
    column -t -s, "$temp_file"
fi
pause
}

delete_book(){
view_books
read -p "Enter title to delete: " title

grep -iv "$title" "$record_file" > "$temp_file"

if confirm; then
    mv "$temp_file" "$record_file"
    echo "Book deleted."
fi
pause
}

edit_book(){
view_books
read -p "Enter title to edit: " title

grep -iv "$title" "$record_file" > "$temp_file"

if confirm; then
    mv "$temp_file" "$record_file"
    echo "Enter new book details:"
    add_book
fi
}

# 🔁 Main Loop
while true
do
    menu
    case $choice in
        1) add_book;;
        2) search_book;;
        3) edit_book;;
        4) delete_book;;
        5) view_books;;
        6) echo "Goodbye!"; exit;;
        *) echo "Invalid choice"; pause;;
    esac
done
