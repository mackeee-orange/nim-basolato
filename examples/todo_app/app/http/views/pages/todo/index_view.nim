import json
import ../../../../../../../src/basolato/view
import ../../layouts/application_view
import ../../layouts/todo/app_bar_view
import ../../layouts/todo/status_view
import ../../layouts/todo/app_bar_view_model
import ./index_view_model

proc impl(viewModel:IndexViewModel):string =
  style "css", style:"""
    <style>
      .columns {
        max-width: 100%;
        margin: auto;
      }
    </style>
  """

  script ["idName"], script:"""
    <script>
    </script>
  """

  tmpli html"""
    $(style)
    <main>
      <header>
        $(appBarView(viewModel.appBarViewModel))
      </header>
      <section class="section">
        $if viewModel.loginUser.isAuth(){
          <p><a href="/todo/create" class="button">
            <i class="fas fa-plus"></i>
            Create new task
          </a></p>
        }
        <article class="columns $(style.element("columns"))">
          $for status in viewModel.data["master"]["status"]{
            $(statusView(status, viewModel.data))
          }
        </article>
      </section>
    </main>
  """

proc indexView*(viewModel:IndexViewModel):string =
  let title = ""
  return applicationView(title, impl(viewModel))
