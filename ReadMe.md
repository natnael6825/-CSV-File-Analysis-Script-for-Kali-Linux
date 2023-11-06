# CSV File Analysis Script for Kali Linux

This Bash script allows you to analyze CSV files on Kali Linux, providing various data insights and manipulation options. It uses Zenity for user-friendly dialog boxes. You can use this script to perform the following operations:

## How to Use the CSV File Analysis Script

1. **Choose a CSV File**: When you run the script, the first step is to choose a CSV file for analysis. You'll be prompted to select the file using a file dialog box.

2. **Display Row and Column Count**: After selecting the CSV file, you can choose the "Display Row and Column Count" option from the menu. This will show you the number of rows and columns in the selected CSV file.

3. **Display Column Names (Header)**: Select the "Display Column Names (Header)" option to view the column names (header) of the CSV file.

4. **List Unique Values in a Column**: If you want to list unique values in a specific column, use the "List Unique Values in a Column" option. You'll be prompted to enter the column number you want to analyze (e.g., $2 for the second column). Make sure to use quotes (") if the column contains string values, and no quotes are needed for numeric columns.

   Example:
   - To list unique values in the second column with string values, enter $2 == "Level 4".
   - To list unique values in the third column with numeric values, enter $3 == 42.

5. **Find Min and Max Values for Numeric Columns**: To find the minimum and maximum values for numeric columns, choose the "Find Min and Max Values for Numeric Columns" option. You'll be prompted to enter the column numbers of the numeric columns you want to analyze (e.g., $2 for the second column).

   Example:
   - To find the min and max values in the second column, enter $2.

6. **Find Most Frequent Value for Categorical Columns**: If you want to find the most frequent value in categorical columns, select the "Find Most Frequent Value for Categorical Columns" option. You'll need to specify the column numbers of the categorical columns.

   Example:
   - To find the most frequent value in the third column, enter $3.

7. **Calculate Summary Statistics for Numeric Columns**: Choose the "Calculate Summary Statistics for Numeric Columns" option to calculate summary statistics for numeric columns. Enter the column numbers of the numeric columns you want to analyze.

   Example:
   - To calculate summary statistics for the fourth column, enter $4.

8. **Filter and Extract Data**: If you want to filter and extract specific rows and columns based on user-defined conditions, use the "Filter and Extract Data" option. Enter the filtering condition (e.g., $2 > 100 && $3 == "Category") and choose a file to save the filtered data.

   Example:
   - To filter data where the second column is greater than 100 and the third column is "Category," enter the condition $2 > 100 && $3 == "Category".

9. **Sort CSV File**: To sort the CSV file based on a specific column, select the "Sort CSV File" option. Enter the column number by which you want to sort the data. The sorting will be alphabetical for string columns and ascending order for numeric columns.

   Example:
   - To sort the data by the fourth column, enter 4.

10. **Exit**: To exit the script, select the "Exit" option.

Make sure to follow the provided examples when using the script. The script will guide you through these steps using Zenity dialog boxes.

## Prerequisites

- Kali Linux
- Bash (Bourne-Again Shell)
- Zenity (for creating graphical user interfaces in shell scripts)

## Statistics for Numeric Columns

When calculating statistics for numeric columns, the script will perform the following checks:

- If the specified column is not a numeric column (contains non-numeric values), the script will reject the operation and provide an error message.

The script ensures that you can perform meaningful statistical calculations only on columns containing numeric values.

## Filtering Data

When using the "Filter and Extract Data" option, you can specify filtering conditions. The script performs the following:

- If you provide a condition for a column that contains string values, you should enclose the string value in double quotes (e.g., $2 == "Level 4").
- If you provide a condition for a column that contains numeric values, you can use operators such as <, >, and == without double quotes (e.g., $3 > 100).

Please make sure to adhere to these guidelines when filtering data.

## Sorting CSV File

When you choose to sort the CSV file using the "Sort CSV File" option, the script performs the following:

- If the specified column is a string column, the data is sorted alphabetically.
- If the specified column is a numeric column, the data is sorted in ascending order.



## Acknowledgments

- [Zenity](https://wiki.gnome.org/Projects/Zenity) - A tool for creating graphical user interfaces in shell scripts.
- Inspired by the need for a simple CSV analysis tool.

Feel free to modify and enhance the script as needed and contribute to this repository.

Happy data analysis!
