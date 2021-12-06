view: sql_derived_table {
  derived_table: {
    sql: SELECT
          `orders`.`id` AS `orders.id`,
          `orders`.`status` AS `orders.status`,
          COUNT(DISTINCT orders.id ) AS `orders.count`,
          COALESCE(SUM(`order_items`.`sale_price`), 0) AS `order_items.total_sale_price`
      FROM
          `demo_db`.`order_items` AS `order_items`
          LEFT JOIN `demo_db`.`orders` AS `orders` ON `order_items`.`order_id` = `orders`.`id`
      GROUP BY
          1,
          2
      ORDER BY
          COUNT(DISTINCT orders.id ) DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: orders_id {
    type: number
    sql: ${TABLE}.`orders.id` ;;
  }

  dimension: orders_status {
    type: string
    sql: ${TABLE}.`orders.status` ;;
  }

  dimension: orders_count {
    type: number
    sql: ${TABLE}.`orders.count` ;;
  }

  dimension: order_items_total_sale_price {
    type: number
    sql: ${TABLE}.`order_items.total_sale_price` ;;
  }

  set: detail {
    fields: [orders_id, orders_status, orders_count, order_items_total_sale_price]
  }
}
