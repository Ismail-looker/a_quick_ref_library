view: users {
  sql_table_name: demo_db.users ;;
  drill_fields: [id]

  filter: order_date {
    label: "Order Date"
    type: date
  }

  filter: users_state {
    label: "Users State"
    type: string
    suggest_dimension: state
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
    style: integer
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    description: "Concantenate First and last name"
    type: string
    sql: concat( ${TABLE}.first_name," ", ${TABLE}.last_name) ;;
    # link: {
    #   label: "{{full_name._value}}"
    #   url: "/explore/a_quick_ref_library/order_items?fields=users.full_name,users.email,users.age,users.state,users.city,order_items.total_sale_price,orders.count&f[users.full_name]={{ value }}&origin=drill-menu"
    # }
   html: <a href="/explore/a_quick_ref_library/order_items?fields=users.full_name,users.email,users.age,users.state,users.city,order_items.total_sale_price,orders.count&f[users.full_name]={{ value }}"> {{value}}</a> ;;
  }

  dimension: first_letter {     # Create a dimension called "first_letter"
    description: "Perform a SQL calculation based on the `full_name` dimension"
    sql: SUBSTR(${full_name},1,1) ;; # Perform a SQL calculation based on the "full_name" dimension
  }

  dimension: gender {
    type: string
    case: {
      when: {
        sql: ${TABLE}.gender = "f" ;;
        label: "Female"
      }
      when: {
        sql: ${TABLE}.gender = "m" ;;
        label: "Male"
      }
    }
    # sql: ${TABLE}.gender ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: region {  # Create a dimension called "region"
    case: {            # Define a set of cases and the corresponding labels for those cases

      # When the "state" dimension has a western state, label it "West"
      when: {
        sql: ${state} in ('WA','OR','CA','NV','UT','WY','ID','MT','CO','AK','HI') ;;
        label: "West"
      }

      # When the "state" dimension has a southwestern state, label it "Southwest"
      when: {
        sql: ${state} in ('AZ','NM','TX','OK') ;;
        label: "Southwest"
      }

      # When the "state" dimension has a midwestern state, label it "Midwest"
      when: {
        sql: ${state} in ('ND','SD','MN','IA','WI','MN','OH','IN','MO','NE','KS','MI','IL') ;;
        label: "Midwest"
      }

      # When the "state" dimension has a northeastern state, label it "Northeast"
      when: {
        sql: ${state} in ('MD','DE','NJ','CT','RI','MA','NH','PA','NY','VT','ME','DC') ;;
        label: "Northeast"
      }

      # When the "state" dimension has a southeastern state, label it "Southeast"
      when: {
        sql: ${state} in ('AR','LA','MS','AL','GA','FL','SC','NC','VA','TN','KY','WV') ;;
        label: "Southeast"
      }

      # If none of the above conditions are satisfied, label it "Unknown"
      else: "Unknown"
    }
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: men_count {
    type: count
    filters: {
      field: gender
      value: "Male"
    }
  }

  measure: female_count {
    type: count
    filters: {
      field: gender
      value: "Female"
    }
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_total {
    type: number
    # sql: (SELECT COUNT(DISTINCT users.id ) FROM demo_db.users);;
    sql: (SELECT
          COUNT(DISTINCT users.id ) AS `users.count`
      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
      LEFT JOIN demo_db.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      LEFT JOIN demo_db.products  AS products ON inventory_items.product_id = products.id
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id
      LIMIT 1);;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      saralooker.count,
      sindhu.count,
      user_data.count
    ]
  }
}
