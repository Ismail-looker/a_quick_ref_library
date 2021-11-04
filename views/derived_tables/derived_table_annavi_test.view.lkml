view: derived_table_annavi_test {
  derived_table: {
    sql: SELECT
    `order_items`.`id` AS `order_items.id`,
    `orders`.`status` AS `orders.status`,
    `order_items`.`inventory_item_id` AS `order_items.inventory_item_id`,
    `order_items`.`order_id` AS `order_items.order_id`,
    `order_items`.`sale_price` AS `order_items.sale_price`
      FROM
          `demo_db`.`order_items` AS `order_items`
          LEFT JOIN `demo_db`.`orders` AS `orders`
          ON (`order_items`.`order_id` = `orders`.`id`)
          AND (tp.source like {% parameter status_parameter %} or {% parameter status_parameter %} = '%%')
          ;;

  #This custom derived table parameter code is not expected to work, only to check the sql generation #
  }



  parameter: status_parameter {
    type: string
    suggest_dimension: status

  }


 measure: count {
  type: count

}
dimension: status {
  type: string
  sql: ${TABLE}.`orders.status` ;;
}

dimension: order_items_id {
  type: number
  sql: ${TABLE}.`order_items.id` ;;
}

dimension: order_items_inventory_item_id {
  type: number
  sql: ${TABLE}.`order_items.inventory_item_id` ;;
}

dimension: order_items_order_id {
  type: number
  sql: ${TABLE}.`order_items.order_id` ;;
}

dimension: order_items_sale_price {
  type: number
  sql: ${TABLE}.`order_items.sale_price` ;;
}

# dimension: inventory_items_cost {
#   type: number
#   sql: ${TABLE}.`inventory_items.cost` ;;
# }

# dimension: inventory_items_id {
#   type: number
#   sql: ${TABLE}.`inventory_items.id` ;;
# }

# dimension: inventory_items_product_id {
#   type: number
#   sql: ${TABLE}.`inventory_items.product_id` ;;
# }

# set: detail {
#   fields: [
#     order_items_id,
#     order_items_inventory_item_id,
#     order_items_order_id,
#     order_items_sale_price,
#     inventory_items_cost,
#     inventory_items_id,
#     inventory_items_product_id
#   ]
# }
}
