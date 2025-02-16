import json
import ../../../../../../../src/basolato/view
import ../../layouts/application_view

style "css", style:"""
<style>
  @media screen{
    main{
      display: flex;
      align-items: center;
    }
  }
  .section{
    margin: auto;
    min-width: 60%;
  }
  .nav{
    display: flex;
    justify-content: space-between;
  }
</style>
"""

proc impl(params, errors:JsonNode):string = tmpli html"""
$(style)
<main>
  <section class="section $(style.element("section"))">
    <form method="POST" class="box">
      $(csrfToken())
      <h2 class="title">Sign Up</h2>
      <article class="field">
        <div class="controll">
          <input type="text" class="input" name="name" placeholder="name" value="$(old(params, "name"))">
        </div>
        $if errors.hasKey("name"){
          <aside>
            $for error in errors["name"]{
              <p class="help is-danger">$(error.get)</p>
            }
          </aside>
        }
      </article>
      <article class="field">
        <div class="controll">
          <input type="text" class="input" name="email" placeholder="email" value="$(old(params, "email"))">
        </div>
        $if errors.hasKey("email"){
          <aside>
            $for error in errors["email"]{
              <p class="help is-danger">$(error.get)</p>
            }
          </aside>
        }
      </article>
      <article class="field">
        <input type="password" class="input" name="password" placeholder="password">
        $if errors.hasKey("password"){
          <aside>
            $for error in errors["password"]{
              <p class="help is-danger">$(error.get)</p>
            }
          </aside>
        }
      </article>
      <article class="field">
        <input type="password" class="input" name="password_confirm" placeholder="password confirm">
        $if errors.hasKey("password_confirm"){
          <aside>
            $for error in errors["password_confirm"]{
              <p class="help is-danger">$(error.get)</p>
            }
          </aside>
        }
      </article>
      $if errors.hasKey("error"){
        <article class="field">
          $for error in errors["error"]{
            <p>$(error.get)</p>
          }
        </article>
      }
      </article>
      <article class="field $(style.element("nav"))">
        <a href="/signin">Sign in here</a>
        <button type="submit" class="button is-link">Sign Up</button>
      </article>
    </form>
  </section>
</main>
"""

proc signupView*(params, errors:JsonNode):string =
  let title = "Sign Up"
  return applicationView(title, impl(params, errors))
