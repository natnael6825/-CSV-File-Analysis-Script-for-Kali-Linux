#!/bin/bash

# Function to check if the file is a CSV file
check_csv_file() {
  local csv_file="$1"
  while true; do
    if [ ! -f "$csv_file" ]; then
      zenity --error --text="Error: File '$csv_file' does not exist."
      zenity --question --text="Retry?"
      if [ $? -ne 0 ]; then
        exit 1
      fi
      csv_file=$(zenity --file-selection --title="Select CSV File")
    elif [[ "$csv_file" != *.csv ]]; then
      zenity --error --text="Error: '$csv_file' is not a CSV file."
      zenity --question --text="Retry?"
      if [ $? -ne 0 ]; then
        exit 1
      fi
      csv_file=$(zenity --file-selection --title="Select CSV File")
    else
      break
    fi
  done
}







# Function to display the number of rows and columns
display_row_column_count() {
  local csv_file="$1"
  local num_rows=$(awk -F',' 'END {print NR}' "$csv_file")
  local num_cols=$(awk -F',' 'NR==1 {print NF}' "$csv_file")
  zenity --info --text="Number of rows: $num_rows\nNumber of columns: $num_cols"
}

# Function to display column names (header)
display_column_names() {
  local csv_file="$1"
  local header=$(head -1 "$csv_file")
  zenity --info --text="Column names: $header"
}

# Function to list unique values in a specified column
list_unique_values() {
  local csv_file="$1"
  local specified_column="$2"
  local unique_values=$(cut -d',' -f"$specified_column" "$csv_file" | sort | uniq)
  zenity --info --text="Unique values in column $specified_column:\n$unique_values"
}

# Function to find minimum and maximum values for numeric columns
find_min_max_numeric() {
  local csv_file="$1"
  local numeric_columns="$2"
  for col in $numeric_columns; do
    # Check if the specified column is numeric (contains only numbers)
    if ! awk -F',' 'NR>1 {if (!($'$col' ~ /^[0-9]*\.?[0-9]+$/)) exit 1}' "$csv_file"; then
      zenity --error --text="Error: Column $col is not numeric."
      continue  # Skip to the next column
    fi

    local min=$(awk -F',' 'NR>1 {print $'$col'}' "$csv_file" | sort -n | head -1)
    local max=$(awk -F',' 'NR>1 {print $'$col'}' "$csv_file" | sort -n | tail -1)
    zenity --info --text="Minimum value in column $col: $min\nMaximum value in column $col: $max"
  done
}







# Function to find the most frequent value (number or word) for categorical columns
find_most_frequent_categorical() {
  local csv_file="$1"
  local categorical_columns="$2"
  for col in $categorical_columns; do
    # Use awk to extract all values from the specified column
    local values=$(cut -d',' -f"$col" "$csv_file" | tail -n +2)  # Skip the header

    # Use awk to count the occurrences of each unique value and store the result
    local frequency_count=$(echo "$values" | awk '{count[$0]++} END {for (val in count) print count[val], val}' | sort -nr)

    # Extract the most frequent value(s)
    local most_frequent=$(echo "$frequency_count" | head -n 1 | awk '{print $2}')

    # Display the most frequent value
    zenity --info --text="Most frequent value in column $col: $most_frequent"
  done
}

# Function to calculate summary statistics for numeric columns
calculate_summary_statistics() {
  local csv_file="$1"
  local numeric_columns="$2"
  for col in $numeric_columns; do
    # Check if the specified column is numeric (contains only numbers)
    if ! awk -F',' 'NR>1 {if (!($'$col' ~ /^[0-9]*\.?[0-9]+$/)) exit 1}' "$csv_file"; then
      zenity --error --text="Error: Column $col is not numeric."
      continue  # Skip to the next column
    fi

    local mean=$(awk -F',' 'NR>1 {sum+=$'$col'} END {print sum/(NR-1)}' "$csv_file")
    local median=$(awk -F',' 'NR>1 {print $'$col'}' "$csv_file" | sort -n | awk 'function median(x){
                  if (n % 2) return x[(n+1)/2];
                  else return (x[n/2] + x[n/2+1]) / 2;
                }
                { x[n++] = $0; }
                END { print median(x); }')
    local std_dev=$(awk -F',' -v mean="$mean" 'NR>1 {sum+=$'$col'^2} END {print sqrt(sum/(NR-1)-mean^2)}' "$csv_file")
    
    zenity --info --text="Summary statistics for column $col:\nMean: $mean\nMedian: $median\nStandard Deviation: $std_dev"
  done
}

# Function to filter and extract rows and columns based on user-defined conditions
filter_and_extract_data() {
  local csv_file="$1"
  local output_file="$2"
  local condition="$3"
  awk -F',' "NR==1 || ($condition)" "$csv_file" > "$output_file.csv"
  if [ $? -eq 0 ]; then
    zenity --info --text="Filtered data is saved in $output_file.csv"
  else
    zenity --error --text="Error occurred while filtering data."
    exit 1
  fi
}

# Function to sort the CSV file based on a specific column
sort_csv() {
  local csv_file="$1"
  local sort_column="$2"

  # Extract the header (first line) from the CSV
  header=$(head -n 1 "$csv_file")

  # Sort the CSV file (skipping the header)
  sorted_data=$(tail -n +2 "$csv_file" | sort -t',' -k"$sort_column")

  if [ $? -eq 0 ]; then
    # Create the sorted CSV file name
    sorted_csv="${csv_file%.*}_sorted.csv"

    # Reattach the header to the sorted data and save it to the sorted CSV file
    echo "$header" > "$sorted_csv"
    echo "$sorted_data" >> "$sorted_csv"

    zenity --info --text="Sorted data is saved in $sorted_csv"
  else
    zenity --error --text="Error occurred while sorting data."
    exit 1
  fi
}

# Main menu using Zenity
while true; do
  choice=$(zenity --list --title="CSV File Analysis Menu" --column="Option"  --width=400 --height=400 \
    "Enter CSV File" "Display Row and Column Count" "Display Column Names (Header)" \
    "List Unique Values in a Column" "Find Min and Max Values for Numeric Columns" \
    "Find Most Frequent Value for Categorical Columns" "Calculate Summary Statistics for Numeric Columns" \
    "Filter and Extract Data" "Sort CSV File" "Exit")

  case "$choice" in
    "Enter CSV File")
      csv_file=$(zenity --file-selection --title="Select CSV File")
      check_csv_file "$csv_file"
      ;;
    "Display Row and Column Count")
      if [ -n "$csv_file" ]; then
        display_row_column_count "$csv_file"
      else
        zenity --error --text="CSV file not selected."
      fi
      ;;
    "Display Column Names (Header)")
      if [ -n "$csv_file" ]; then
        display_column_names "$csv_file"
      else
        zenity --error --text="CSV file not selected."
      fi
      ;;
    "List Unique Values in a Column")
      if [ -n "$csv_file" ]; then
        col_number=$(zenity --entry --title="Enter Column Number" --text="Enter the column number to list unique values:")
        if [ -n "$col_number" ]; then
          list_unique_values "$csv_file" "$col_number"
        else
          zenity --error --text="Column number not provided."
        fi
      else
        zenity --error --text="CSV file not selected."
      fi
      ;;
    "Find Min and Max Values for Numeric Columns")
      if [ -n "$csv_file" ]; then
        numeric_cols=$(zenity --entry --title="Enter Numeric Column Numbers" --text="Enter numeric column numbers (space-separated):")
        if [ -n "$numeric_cols" ]; then
          find_min_max_numeric "$csv_file" "$numeric_cols"
        else
          zenity --error --text="Numeric column numbers not provided."
        fi
      else
        zenity --error --text="CSV file not selected."
      fi
      ;;
    "Find Most Frequent Value for Categorical Columns")
      if [ -n "$csv_file" ]; then
        categorical_cols=$(zenity --entry --title="Enter Categorical Column Numbers" --text="Enter categorical column numbers (space-separated):")
        if [ -n "$categorical_cols" ]; then
          find_most_frequent_categorical "$csv_file" "$categorical_cols"
        else
          zenity --error --text="Categorical column numbers not provided."
        fi
      else
        zenity --error --text="CSV file not selected."
      fi
      ;;
    "Calculate Summary Statistics for Numeric Columns")
      if [ -n "$csv_file" ]; then
        numeric_cols=$(zenity --entry --title="Enter Numeric Column Numbers" --text="Enter numeric column numbers (space-separated):")
        if [ -n "$numeric_cols" ]; then
          calculate_summary_statistics "$csv_file" "$numeric_cols"
        else
          zenity --error --text="Numeric column numbers not provided."
        fi
      else
        zenity --error --text="CSV file not selected."
      fi
      ;;
    "Filter and Extract Data")
      if [ -n "$csv_file" ]; then
        condition=$(zenity --entry --title="Enter Filter Condition" --text="Enter filter condition (e.g., 'col1 > 100 && col2 < 50'):")
        if [ -n "$condition" ]; then
          output_file=$(zenity --file-selection --save --confirm-overwrite --title="Save Filtered Data As" --file-filter="CSV Files | *.csv")
          if [ -n "$output_file" ]; then
            filter_and_extract_data "$csv_file" "$output_file" "$condition"
          else
            zenity --error --text="Output file not provided."
          fi
        else
          zenity --error --text="Filter condition not provided."
        fi
      else
        zenity --error --text="CSV file not selected."
      fi
      ;;
    "Sort CSV File")
      if [ -n "$csv_file" ]; then
        sort_col=$(zenity --entry --title="Enter Column Number to Sort By" --text="Enter column number to sort by:")
        if [ -n "$sort_col" ]; then
          sort_csv "$csv_file" "$sort_col"
        else
          zenity --error --text="Sort column number not provided."
        fi
      else
        zenity --error --text="CSV file not selected."
      fi
      ;;
    "Exit")
      exit 0
      ;;
    *)
      zenity --error --text="Invalid choice. Please select a valid option."
      ;;
  esac
done



