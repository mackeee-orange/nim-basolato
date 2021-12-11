import re
# framework
import ../../src/basolato
# controller
import app/http/controllers/sign/signin_controller
import app/http/controllers/sign/signup_controller
import app/http/controllers/todo_controller
# middleware
import app/http/middlewares/auth_middleware
import app/http/middlewares/cors_middleware

var routes = Routes.new()
routes.middleware(re".*", auth_middleware.checkCsrfTokenMiddleware)
routes.middleware(re"/api/.*", cors_middleware.setCorsHeadersMiddleware)

routes.middleware(re"/(signin|signup)", auth_middleware.loginSkip)
routes.get("/signin", signin_controller.index)
routes.post("/signin", signin_controller.store)
routes.get("/signout", signin_controller.delete)
routes.get("/signup", signup_controller.index)
routes.post("/signup", signup_controller.store)

routes.get("/", todo_controller.toppage)

routes.middleware(re"/todo", auth_middleware.mustBeLoggedIn)
groups "/todo":
  routes.get("", todo_controller.index)
  routes.get("/create", todo_controller.create)
  routes.post("/create", todo_controller.store)
  routes.post("/change-sort", todo_controller.changeSort)
  routes.post("/{uuid:string}", todo_controller.show)

serve(routes)
