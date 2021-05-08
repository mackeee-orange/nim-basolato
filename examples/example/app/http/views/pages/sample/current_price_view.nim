import os, json
import ../../../../../../../src/basolato/view
import ../../layouts/application_view

style "css", style:"""
.className {
}
"""

proc impl(price:JsonNode):string = tmpli html"""
$(style)
<script src="/js/sample/current_price.js"></script>
<div class="$(style.get("className"))">
  <button onclick="print('aaa')">print</button>
  <button onclick="fetchCurrency">ajax</button>
  <p>updated time：$(price["fetchTime"].get)</p>
  <table>
    <tr>
      <th>currency</th><th>rate</th><th>description</th>
    </tr>
    <tr><td>USD</td><td>$(price["usd"]["rate"].get)</td><td>$(price["usd"]["description"].get)</td></tr>
    <tr><td>GBP</td><td>$(price["gbp"]["rate"].get)</td><td>$(price["gbp"]["description"].get)</td></tr>
    <tr><td>EUR</td><td>$(price["eur"]["rate"].get)</td><td>$(price["eur"]["description"].get)</td></tr>
  </table>
</div>
"""

proc currentPriceView*(price:JsonNode):string =
  let title = ""
  return applicationView(title, impl(price))
