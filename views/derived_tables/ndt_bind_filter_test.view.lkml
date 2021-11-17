# If necessary, uncomment the line below to include explore_source.
include: "/models/a_quick_ref_library.model.lkml"

view: ndt_bind_filter_test {
    derived_table: {
      explore_source: order_items {
        column: created_date { field: orders.created_date }
        column: status { field: orders.status }
        column: count { field: orders.count }
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
    dimension: count {
      type: number
    }
    # dimension: returned_date {
    #   type: date
    # }
  }
