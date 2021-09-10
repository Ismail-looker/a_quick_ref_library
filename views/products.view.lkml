view: products {
  sql_table_name: demo_db.products ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }


# Description: Simple use of liquid value variable in link parameter
# Feature(s): Using `{{ value }}` from HTML liquid variables
# Ref link: https://docs.looker.com/reference/liquid-variables#:~:text=Field%20Values-,value,-The%20raw%20value
# Created by: Ismail A. Sept 2021
# Updates by: Ismail A. Sept 2021, ...
  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Google Search"
      url: "http://www.google.com/search?q={{ value }}+Clothing"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    html: <a target="_blank" href="https://www.google.com/">Link to Google</a>;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

# Wrap Column header but truncate row entries in a table
# Feature(s): Using Liquid Filter `truncate`
# Ref link: https://shopify.github.io/liquid/filters/truncate/
# Created by: Ismail A. Sept 2021
# Updates by: Ismail A. Sept 2021, ...
  dimension: item_name_truncated {
    type: string
    sql: ${TABLE}.item_name ;;
    html: {{value | truncate: 20}} ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
    value_format_name: usd
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }
}
