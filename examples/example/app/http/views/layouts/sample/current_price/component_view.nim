import json
import ../../../../../../../../src/basolato/view

proc componentView*(price:JsonNode):string = tmpli html"""
<button onclick="print('aaa')">print</button>
  <button onclick="fetchCurrency()">ajax</button>
  <p>updated time：$(price["fetchTime"].get)</p>
  <table>
    <tr>
      <th>currency</th><th>rate</th><th>description</th>
    </tr>
    <tr><td>USD</td><td>$(price["usd"]["rate"].get)</td><td>$(price["usd"]["description"].get)</td></tr>
    <tr><td>GBP</td><td>$(price["gbp"]["rate"].get)</td><td>$(price["gbp"]["description"].get)</td></tr>
    <tr><td>EUR</td><td>$(price["eur"]["rate"].get)</td><td>$(price["eur"]["description"].get)</td></tr>
  </table>
"""
