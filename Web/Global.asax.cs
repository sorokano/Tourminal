using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;

namespace Elcondor {
    
    public class MvcApplication : System.Web.HttpApplication {
        public static void RegisterRoutes (RouteCollection routes) {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.IgnoreRoute("ElcondorWCF.svc/{*pathInfo}");

            routes.MapRoute(
                "Default", // Имя маршрута
                "{action}", // URL-адрес с параметрами
                new { controller = "Home", action = "Index" } // Параметры по умолчанию
            );

            //routes.MapRoute(
            //    "Default11", // Имя маршрута
            //    "{controller}/{action}/{query}", // URL-адрес с параметрами
            //    new { controller = "Admin", action = "Index", query = UrlParameter.Optional } // Параметры по умолчанию
            //);

            //routes.MapRoute(
            //    "Default3", // Имя маршрута
            //    "{controller}/{action}", // URL-адрес с параметрами
            //    new { controller = "Admin", action = "Index" } // Параметры по умолчанию
            //);

            //routes.MapRoute(
            //    "Default2", // Имя маршрута
            //    "{controller}/{action}/{id}", // URL-адрес с параметрами
            //    new { controller = "Admin", action = "Index", id = UrlParameter.Optional } // Параметры по умолчанию
            //);

            routes.MapRoute(
                "Default4", // Имя маршрута
                "Index/{query}", // URL-адрес с параметрами
                new { controller = "Home", action = "Index", query = UrlParameter.Optional } // Параметры по умолчанию
            );


            routes.MapRoute(
                "Default5", // Имя маршрута
                "About/{query}", // URL-адрес с параметрами
                new { controller = "Home", action = "About", query = UrlParameter.Optional } // Параметры по умолчанию
            );

            routes.MapRoute(
                "Default6", // Имя маршрута
                "IndividualTours/{query}", // URL-адрес с параметрами
                new { controller = "Home", action = "IndividualTours", query = UrlParameter.Optional } // Параметры по умолчанию
            );


            routes.MapRoute(
                "Default7", // Имя маршрута
                "Articles/{query}", // URL-адрес с параметрами
                new { controller = "Home", action = "Articles", query = UrlParameter.Optional } // Параметры по умолчанию
            );

            routes.MapRoute(
                "Default8", // Имя маршрута
                "Faq/{query}", // URL-адрес с параметрами
                new { controller = "Home", action = "Faq", query = UrlParameter.Optional } // Параметры по умолчанию
            );


            routes.MapRoute(
                "Default9", // Имя маршрута
                "Contacts/{query}", // URL-адрес с параметрами
                new { controller = "Home", action = "Contacts", query = UrlParameter.Optional } // Параметры по умолчанию
            );
            routes.MapRoute(
                "Default10", // Имя маршрута
                "Avia/{query}", // URL-адрес с параметрами
                new { controller = "Home", action = "Avia", query = UrlParameter.Optional } // Параметры по умолчанию
            );
            routes.MapRoute(
                "Default12", // Имя маршрута
                "{controller}/{action}/{id}", // URL-адрес с параметрами
                new { controller = "Home", action = "Index", id = UrlParameter.Optional } // Параметры по умолчанию
            );
            routes.MapRoute(
                "Default13", // Имя маршрута
                "Rent/{id}", // URL-адрес с параметрами
                new { controller = "Home", action = "Rent", id = UrlParameter.Optional } // Параметры по умолчанию
            );
        }

        protected void Application_Start () {
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);
        }

        protected void Application_BeginRequest (object sender, EventArgs e) {
            /* we guess at this point session is not already retrieved by application so we recreate cookie with the session id... */
            try {
                string session_param_name = "ASPSESSID";
                string session_cookie_name = "ASP.NET_SessionId";

                if (HttpContext.Current.Request.Form[session_param_name] != null) {
                    UpdateCookie(session_cookie_name, HttpContext.Current.Request.Form[session_param_name]);
                } else if (HttpContext.Current.Request.QueryString[session_param_name] != null) {
                    UpdateCookie(session_cookie_name, HttpContext.Current.Request.QueryString[session_param_name]);
                }
            } catch {
            }

            try {
                string auth_param_name = "AUTHID";
                string auth_cookie_name = FormsAuthentication.FormsCookieName;

                if (HttpContext.Current.Request.Form[auth_param_name] != null) {
                    UpdateCookie(auth_cookie_name, HttpContext.Current.Request.Form[auth_param_name]);
                } else if (HttpContext.Current.Request.QueryString[auth_param_name] != null) {
                    UpdateCookie(auth_cookie_name, HttpContext.Current.Request.QueryString[auth_param_name]);
                }

            } catch {
            }
        }

        private static void HandleAjax (HttpContext context) {
            int dotasmx = context.Request.Path.IndexOf(".php");

            string path = context.Request.Path.Substring(0, dotasmx + 4);

            string pathInfo = context.Request.Path.Substring(dotasmx + 4);

            context.RewritePath(path, pathInfo, context.Request.Url.Query);

        }

        private void UpdateCookie (string cookie_name, string cookie_value) {
            HttpCookie cookie = HttpContext.Current.Request.Cookies.Get(cookie_name);
            if (null == cookie) {
                cookie = new HttpCookie(cookie_name);
            }
            cookie.Value = cookie_value;
            HttpContext.Current.Request.Cookies.Set(cookie);
        }
        
        void Session_Start (object sender, EventArgs e) {
            // Code that runs when a new session is started
            string sessionId = Session.SessionID;
        }
    }
}