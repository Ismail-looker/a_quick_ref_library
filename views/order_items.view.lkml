view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

dimension_group: date_diff {
  type: duration
  sql_start: ${orders.created_raw} ;;  # often this is a single database column
  sql_end: ${returned_raw} ;;  # often this is a single database column
  intervals: [day,month,quarter,week,year]
}

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sale Price"
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sale Price"
  }

  measure: least_expensive_item {
    type: min
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sale Price"
  }

  measure: most_expensive_item {
    type: max
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sale Price"
  }

  parameter: sale_price_metric_picker {
    description: "Use with the Sale Price Metric measure"
    type: unquoted
    allowed_value: {
      label: "Total Sale Price"
      value: "SUM"
    }
    allowed_value: {
      label: "Average Sale Price"
      value: "AVG"
    }
    allowed_value: {
      label: "Maximum Sale Price"
      value: "MAX"
    }
    allowed_value: {
      label: "Minimum Sale Price"
      value: "MIN"
    }
  }

  measure: sale_price_metric {
    description: "Use with the Sale Price Metric Picker filter-only field"
    type: number
    label_from_parameter: sale_price_metric_picker
    sql: {% parameter sale_price_metric_picker %}(${sale_price}) ;;
    value_format_name: usd
  }

  filter: category_count_picker {
    description: "Use with the Category Count measure"
    type: string
    suggest_explore: order_items
    suggest_dimension: products.category
  }

  measure: category_count {
    description: "Use with the Category Count Picker filter-only field"
    type: sum
    sql:
      CASE
        WHEN {% condition category_count_picker %} ${products.category} {% endcondition %}
        THEN 1
        ELSE 0
      END
    ;;
  }

  # measure: total_profit {
  #   type: number
  #   sql: ${total_sale_price} - ${products.total_cost} ;; missing cost dimension
  #   value_format_name: usd
  # }
}
