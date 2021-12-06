view: sql_derived_table {
  derived_table: {
    sql: SELECT
          `orders`.`id` AS `orders.id`,
          `orders`.`status` AS `orders.status`,
          `order_items`.`sale_price` AS `order_items.sale_price`,
          TIMESTAMPDIFF(MONTH, (DATE_ADD(orders.created_at, INTERVAL 3 YEAR)) , order_items.returned_at ) AS `order_items.months_date_diff`,
          COUNT(DISTINCT orders.id ) AS `orders.count`,
          COALESCE(SUM(`order_items`.`sale_price`), 0) AS `order_items.total_sale_price`
      FROM
          `demo_db`.`order_items` AS `order_items`
          LEFT JOIN `demo_db`.`orders` AS `orders` ON `order_items`.`order_id` = `orders`.`id`
      GROUP BY
          1,
          2,
          3,
          4
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

  dimension: order_items_sale_price {
    type: number
    sql: ${TABLE}.`order_items.sale_price` ;;
  }

  dimension: order_items_months_date_diff {
    type: number
    sql: ${TABLE}.`order_items.months_date_diff` ;;
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
    fields: [
      orders_id,
      orders_status,
      order_items_sale_price,
      order_items_months_date_diff,
      orders_count,
      order_items_total_sale_price
    ]
  }
}
