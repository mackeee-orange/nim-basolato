import json, tables
import ../../../../../../../../src/basolato/view
import ../../layouts/application_view

style "css", style:
  """
.errors{
  background-color: pink;
  color: red;
}
"""

proc impl(params, errors:JsonNode):string = tmpli html"""
$(style)
<section class="section">
  <div class="container is-max-desktop">
    <div class="card">
      <div class="card-header">
        <div class="card-header-title"> Todo App Sign In</div>
      </div>
      <div class="card-content">
        <form method="POST">
          $(csrfToken())

          <div class="field">
            <p class="control has-icons-left">
              <input type="text" name="email" placeholder="email" value="$(old(params, "email"))" class="input" >
              <span class="icon is-small is-left">
                <i class="fas fa-envelope"></i>
              </span>
            </p>
            $if errors.hasKey("email"){
              <ul class="$(style.element("errors"))">
                $for error in errors["email"] {
                  <li>$(error.get())</li>
                }
              </ul>
            }
          </div>

          <div class="field">
            <p class="control has-icons-left">
              <input type="password" name="password" placeholder="password" class="input" >
              <span class="icon is-small is-left">
                <i class="fas fa-lock"></i>
              </span>
            </p>
            $if errors.hasKey("password"){
              <ul class="$(style.element("errors"))">
                $for error in errors["password"] {
                  <li>$(error.get())</li>
                }
              </ul>
            }
          </div>

          $if errors.hasKey("core"){
            <div class="field">
              <ul class="$(style.element("errors"))">
                $for error in errors["core"] {
                  <li>$(error.get())</li>
                }
              </ul>
            </div>
          }

          <div class="field">
            <button type="submit" class="button is-primary is-light is-outlined">signin</button>
          </div>
        </form>
      </div>
      <a href="/signup">Sign up here</a>
    </div>
  </div>
</section>
"""

proc signinView*(client:Client):Future[string] {.async.} =
  let title = "Sign in"
  let (params, errors) = await client.getValidationResult()
  return applicationView(title, impl(params, errors))
