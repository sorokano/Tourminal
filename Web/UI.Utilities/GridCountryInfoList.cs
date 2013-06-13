using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.UI.Utilities {
    public static class GridCountryInfoList {
        public static string GetGridHTML (List<TblCountryInfo> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GetHeader());
            foreach (TblCountryInfo itm in items) {
                sb.Append(GetFormattedRow(itm.Id, itm.Title, itm.CountryId));
            }
            sb.Append(GetFooter());
            return sb.ToString();
        }

        public static string GetContentsHTML (List<TblCountryInfo> items) {
            StringBuilder sb = new StringBuilder();
            int countryId = 0;
            sb.Append("<br />");
            sb.Append("<br />");
            foreach (TblCountryInfo itm in items) {
                countryId = itm.CountryId;
                sb.Append("<div class=\"infoContentSection\">");
                string description = itm.Description;
                description = description.Replace("style=", " ");
                description = description.Replace("class=", " ");
                sb.Append(string.Format("<a name=\"tag{0}\">{1}</a><br/><br/><div class=\"graypanel\">{2}</div>", itm.Id, itm.Title, description));
                sb.Append("</div>");
            }
            sb.Append(string.Format("<span style=\"float:right;padding-right:25px;\"><a href=\"../../CountryAbout?id={0}#pagetop\">Наверх</a></span><br/>", countryId));
            return sb.ToString();
        }

        private static string GetFormattedRow (int id, string title, int countryId) {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<tr>");
            stringBuilder.Append("<td style=\"padding:0;\">");
            stringBuilder.Append(string.Format("<a href=\"../../CountryAbout?id={0}#tag{1}\">{2}</a>", countryId, id, title));
            stringBuilder.Append("</td>");
            stringBuilder.Append("</tr>");            
            return stringBuilder.ToString();
        }

        private static string GetHeader () {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<table style=\"width:305px;border:0px;\">");
            return stringBuilder.ToString();
        }

        private static string GetFooter () {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("</table>");
            return stringBuilder.ToString();
        }
    }
}