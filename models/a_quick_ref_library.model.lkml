connection: "quick_ref_library_thelook_mysql"

# include all the views
include: "/views/**/*.view"

datagroup: a_quick_ref_library_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: lookml_training {
  sql_trigger: SELECT DATE_PART('hour', GETDATE()) ;;
  max_cache_age: "1 hour"
}


persist_with: a_quick_ref_library_default_datagroup

explore: order_items {
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_order_facts {
    sql_on: ${user_order_facts.user_id} = ${users.id} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

join: ndt_bind_filter_test {
  type: left_outer
  relationship: one_to_one
  sql_on: ${ndt_bind_filter_test.status} = ${orders.status} ;;
}
}


explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products {}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: user_order_facts {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: flights {}

explore: derived_table_annavi_test {
  always_filter: {
    filters: [derived_table_annavi_test.status_parameter: "^%^%"]
  }
  }

explore: ndt_bind_filter_test {
  view_name: ndt_bind_filter_test
  fields: [ALL_FIELDS*,- order_items.category_count, - order_items.days_date_diff
    , -order_items.months_date_diff
    , - order_items.quarters_date_diff
    , - order_items.weeks_date_diff
    , - order_items.years_date_diff]
  join: order_items {
    type: cross
    relationship: many_to_one
sql_on:${ndt_bind_filter_test.order_id} =  ${order_items.id}  ;;
}

join: ndt_bind_filter_text_second {
  type: inner
  relationship:one_to_one
  sql_on: ${ndt_bind_filter_test.status} = ${ndt_bind_filter_text_second.status};;
}

# join: orders {
#   type: left_outer
#   relationship: one_to_one
#   sql_on: ${ndt_bind_filter_test.status} = ${orders.status} ;;
# }
}

explore: sql_derived_table{}
