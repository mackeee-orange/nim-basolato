import os
import ../../../../../../../src/basolato/view
import ../../layouts/application_view

style "css", style:"""
.className {
}
"""

proc impl():string = tmpli html"""
$(style)
<script src="/js/current_price.js"></script>
<div class="$(style.get("className"))">
  <button onclick="print('aaa')">print</button>
</div>
"""

proc currentPriceView*():string =
  let title = ""
  return applicationView(title, impl())
