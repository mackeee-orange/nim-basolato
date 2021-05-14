import json
import ../../../../../../../src/basolato/view
import ../../layouts/application_view
import ../../layouts/sample/current_price/component_view

style "css", style:"""
.className {
}
"""

proc impl(price:JsonNode):string = tmpli html"""
$(style)
<script src="/js/sample/current_price.js"></script>
<div id="component" class="$(style.get("className"))">
  $(componentView(price))
</div>
"""

proc currentPriceView*(price:JsonNode):string =
  let title = ""
  return applicationView(title, impl(price))
