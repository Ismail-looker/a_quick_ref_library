view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: DATE_ADD(${TABLE}.created_at, INTERVAL 3 YEAR) ;;
  }

  ################### Formatting dates with Liquid   ###################
  dimension: date_formatted_ddmmyyy {
    description: "Format date as ddmmyy instead of yyyymmdd and conditionally show time part if hour-min isn't 00:00"
    group_label: "Liquid Date Formatting"
    sql: ${created_date} ;;
    html: {% assign hour = created_hour._value | split: " " | last %}
          {% assign minute = created_minute._value | split: ":" | last %}
          {% assign seconds = created_time._value | split: ":" | last %}
          {% if hour == "00" and minute == "00" %}
            {{ rendered_value | date: "%d-%m-%Y" }}
          {% else %}
            {{ rendered_value | date: "%d-%m-%Y"}} {{hour}}:{{minute}}:{{seconds}}
          {% endif %}
    ;; # Split the timeframes by delimiters and get the last part then assign to variables
  }

  dimension: first_day_of_week{
    group_label: "Liquid Date Formatting"
    sql: ${created_week} ;;
    html: {{ value | date: "%B %d" }};;
  }

  dimension: first_day_of_week_2{
    group_label: "Liquid Date Formatting"
    sql: ${created_week} ;;
    html: {{ value | date: "Week %U (%B %d)" }};;
  }

  dimension: date_formatted {
    group_label: "Liquid Date Formatting"
    label: "Date"
    sql: ${created_date} ;;
    html: {{ rendered_value | date: "%d-%B-%y" }};;
  }


  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    html:
      {% if value == 'complete' %}
        <div style="background-color:#D5EFEE">{{ value |capitalize }}</div>
      {% elsif value == 'processing' or value == 'shipped' or value == 'pending' %}
        <div style="background-color:#FCECCC">{{ value | capitalize }}</div>
      {% elsif value == 'cancelled' or value == 'returned' %}
        <div style="background-color:#EFD5D6">{{ value |capitalize }}</div>
      {% endif %}
    ;;
  }

  dimension: is_complete {
    type: yesno
    sql: ${status} = 'complete' ;;
  }

  dimension: is_cancelled {
    type: yesno
    sql: ${status} = 'cancelled' ;;
  }

  dimension: is_pending {
    type: yesno
    sql: ${status} = 'pending' ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

# Description: Maintaining drill-down links (To maintain drill-down links when formatting output using the html parameter)
# Feature(s): HTML tag <a href="#drillmenu" target="_self">
# Ref link: https://docs.looker.com/reference/field-params/html#maintaining_drill-down_links
# Created by: Ismail A. Sept 2021
# Updates by: Ismail A. Sept 2021, ...
  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
    html:
    <a href="#drillmenu" target="_self">
      {% if value > 10000 %}
        <font color="#42a338 ">{{ rendered_value }}</font>
      {% elsif value > 5000 %}
        <font color="#ffb92e ">{{ rendered_value }}</font>
      {% else %}
        <font color="#fa4444 ">{{ rendered_value }}</font>
      {% endif %}
    </a>;;
  }

  measure: nbr_format_count {
    description: "Conditional Number format using liquid and LookML constant"
    type: number
    sql: ${count} ;;
    html: @{BigNumbers_format} ;;
  }

}
