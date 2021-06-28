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
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    html:
      {% if value == 'Complete' %}
        <div style="background-color:#D5EFEE">{{ value }}</div>
      {% elsif value == 'Processing' or value == 'Shipped' %}
        <div style="background-color:#FCECCC">{{ value }}</div>
      {% elsif value == 'Cancelled' or value == 'Returned' %}
        <div style="background-color:#EFD5D6">{{ value }}</div>
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

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
  }

}
