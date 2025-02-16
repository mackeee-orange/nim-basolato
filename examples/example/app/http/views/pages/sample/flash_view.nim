import json
import ../../../../../../../src/basolato/view
import ../../layouts/application_view

style "css", style:"""
.className {
}
"""

proc impl(context:Context):Future[string]{.async.} = tmpli html"""
<main>
  <a href="/">go back</a>
  <section>
    <form method="POST">
      $(csrfToken())
      <button type="submit">set flash</button>
      $for key, val in await(context.getFlash()).pairs{
        <p>$(val.get())</p>
      }
    </form>
  </section>
</main>
"""

proc flashView*(context:Context):Future[string]{.async.} =
  const title = "Flash message"
  return applicationView(title, await impl(context))
