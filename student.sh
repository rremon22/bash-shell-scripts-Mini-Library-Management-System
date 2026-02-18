#!/bin/bash

record_file="students.db"
temp_file="/tmp/students.$$"

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
echo "   STUDENT MANAGEMENT SYSTEM"
echo "=============================="
echo "1. Add Student"
echo "2. Search Student"
echo "3. Edit Student"
echo "4. Delete Student"
echo "5. View All Students"
echo "6. Exit"
echo "=============================="
read -p "Enter choice: " choice
}

add_student(){
echo "Enter Student ID:"
read id

echo "Enter Student Name:"
read name

echo "Enter Department:"
read dept

echo "Enter GPA:"
read gpa

echo "Enter Phone Number:"
read phone

echo "Adding record..."
echo "$id,$name,$dept,$gpa,$phone" >> "$record_file"
echo " Student added successfully!"
pause
}

view_students(){
echo "===== Student List ====="
if [ ! -s "$record_file" ]; then
    echo "No records found."
else
    column -t -s, "$record_file"
fi
pause
}

search_student(){
read -p "Enter name or ID to search: " search
grep -i "$search" "$record_file" > "$temp_file"

if [ ! -s "$temp_file" ]; then
    echo "No student found."
else
    echo "Found:"
    column -t -s, "$temp_file"
fi
pause
}

delete_student(){
view_students
read -p "Enter student ID to delete: " id

grep -iv "^$id," "$record_file" > "$temp_file"

if confirm; then
    mv "$temp_file" "$record_file"
    echo "Student deleted."
fi
pause
}

edit_student(){
view_students
read -p "Enter student ID to edit: " id

grep -iv "^$id," "$record_file" > "$temp_file"

if confirm; then
    mv "$temp_file" "$record_file"
    echo "Enter new student details:"
    add_student
fi
}

# 🔁 Main Loop
while true
do
    menu
    case $choice in
        1) add_student;;
        2) search_student;;
        3) edit_student;;
        4) delete_student;;
        5) view_students;;
        6) echo "Goodbye!"; exit;;
        *) echo "Invalid choice"; pause;;
    esac
done
