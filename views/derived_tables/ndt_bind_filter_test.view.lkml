# If necessary, uncomment the line below to include explore_source.
include: "/models/a_quick_ref_library.model.lkml"
include: "/views/order_items.view.lkml"
include: "/views/orders.view.lkml"

view: ndt_bind_filter_test {
    derived_table: {
     #  sql_trigger_value: SELECT CURDATE() ;;
      explore_source: order_items {
        column: created_date { field: orders.created_date }
        column: status { field: orders.status }
        column: count { field: orders.count }
        column: id { field: orders.id }
        column: order_id {}
        # column: returned_date {
        #   field: order_items.returned_date
        #   }
        # filters: {
        #   field: order_items.returned_date
        #   value: "7 days"
        # }
        bind_filters: {
          from_field: order_items.returned_date
          to_field: orders.created_date
        }
      }
    }
    dimension: created_date {
      type: date
    }
    dimension: status {}
    measure: count {
      type: number
    }
  dimension: id {
    type: number
  }
  dimension: order_id {
    type: number
  }
    # dimension: returned_date {
    #   type: date
    # }
  }
