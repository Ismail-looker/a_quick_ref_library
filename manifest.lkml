
# #Analysts Channel https://chat.google.com/room/AAAA5AxcJvs/8GWXMJCau-4
#  Conditional formatting for Positive and Negative Numbers
constant: BigNumbers_format {
  value: "
  {% if value < 0 %}
  {% assign abs_value = value | times: -1.0 %}
  {% assign pos_neg = '-' %}
  {% else %}
  {% assign abs_value = value | times: 1.0 %}
  {% assign pos_neg = '' %}
  {% endif %}

  {% if abs_value >=1000000000 %}
  {{pos_neg}}{{ abs_value | divided_by: 1000000000.0 | round: 2 }}B
  {% elsif abs_value >=1000000 %}
  {{pos_neg}}{{ abs_value | divided_by: 1000000.0 | round: 2 }}M
  {% elsif abs_value >=1000 %}
  {{pos_neg}}{{ abs_value | divided_by: 1000.0 | round: 2 }}K
  {% else %}
  {{pos_neg}}{{ abs_value }}
  {% endif %}

  "
}
