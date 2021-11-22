
# If necessary, uncomment the line below to include explore_source.
include: "/models/a_quick_ref_library.model.lkml"
include: "/views/order_items.view.lkml"
# include: "/views/orders.view.lkml"


view: ndt_bind_filter_text_second {
  derived_table: {
    explore_source: ndt_bind_filter_test {
      column: created_date { field:ndt_bind_filter_test.created_date}
      column: status {}
      column: count {}
      # filters: {
      #   field: order_items.returned_date
      #   value: "2019"
      # }
      bind_filters: {
        from_field: order_items.returned_date
        to_field: ndt_bind_filter_test.created_date
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
}
