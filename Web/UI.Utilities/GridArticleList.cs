using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.UI.Utilities {
    public static class GridArticleList {
        public static string GetGridHTML (List<TblSightseeing> items, int countryId, bool isAddViewAllRow) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GetHeader());
            foreach (TblSightseeing itm in items) {
                bool hasImage = false;
                try {
                    hasImage = itm.ThumbImage.Length > 0;
                } catch { hasImage = false; }
                string regCountryNames = BizSightseeing.GetRegionNames(itm.Id);
                sb.Append(
                    GetFormattedRow(itm.Id.ToString(), itm.Name, itm.DateCreated.HasValue ? itm.DateCreated.Value.ToString("dd.MM.yyyy") : string.Empty, hasImage, regCountryNames));
            }
            sb.Append(GetFooter());
            if (isAddViewAllRow) sb.Append(string.Format("<br/><br/><a href=\"../../CountryArticles?id={0}\">Все заметки...</a><br/><br/>", countryId));
            return sb.ToString();
        }

        public static string GetFormattedRow (string tourId, string tourName, string date, bool hasImage, string countryRegion) {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<tr>");
            stringBuilder.Append("<td style=\"width:110px;border-bottom: 1px #847ea4 solid !important;\">");
            if (hasImage)
                stringBuilder.Append(string.Format("<img alt=\"\" style=\"max-width:100px;max-height:80px;\" src=\"../../Content/UserImages/sightseeing_th_{0}.jpg\">", tourId));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td style=\"width:110px;border-bottom: 1px #847ea4 solid !important;\">");
            stringBuilder.Append(string.Format("<a href=\"../../ViewArticle?id={0}\">{1}</a>", tourId, tourName));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td style=\"width:110px;border-bottom: 1px #847ea4 solid !important;\">");
            stringBuilder.Append(date);
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td style=\"width:110px;border-bottom: 1px #847ea4 solid !important;\">");
            stringBuilder.Append(countryRegion);
            stringBuilder.Append("</td>");     
            //stringBuilder.Append("<td>");
            //stringBuilder.Append(string.Format("<a href=\"../../ViewArticle?id={0}\">Подробнее...</a>", tourId));
            //stringBuilder.Append("</td>");

            stringBuilder.Append("</tr>");
            return stringBuilder.ToString();
        }

        public static string GetHeader () {
            StringBuilder stringBuilder = new StringBuilder();
            //stringBuilder.Append("<div>");
            stringBuilder.Append("<table class=\"hightlight\" style=\"width: 100% !important;font-size:14px !important;\">");
            stringBuilder.Append("    <thead>");
            stringBuilder.Append("    <tr>");
            stringBuilder.Append("        <th colspan=\"4\" scope=\"col\">");
            stringBuilder.Append(string.Format("{0}", "Заметки путешественников"));
            stringBuilder.Append("        </th>");
            //stringBuilder.Append("        <td scope=\"col\">");
            //stringBuilder.Append("         &nbsp;   ");
            //stringBuilder.Append("        </td>");
            //stringBuilder.Append("        <td scope=\"col\">");
            //stringBuilder.Append(string.Format("{0}", "Название статьи"));
            //stringBuilder.Append("        </td>");
            //stringBuilder.Append("        <td>Дата создания:");
            //stringBuilder.Append("        </td>");
            //stringBuilder.Append("        <td>");
            //stringBuilder.Append("            Регион:");
            //stringBuilder.Append("        </td>");
            stringBuilder.Append("    </tr>");
            stringBuilder.Append("    </thead>");
            stringBuilder.Append("<tbody>");
            return stringBuilder.ToString();
        }

        public static string GetFooter () {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("</tbody>");
            stringBuilder.Append("<tfoot><tr><th scope=\"row\">&nbsp;</th><td colspan=\"4\">&nbsp;</td></tr></tfoot>");
            stringBuilder.Append("</table>");
            //stringBuilder.Append("</div>");
            return stringBuilder.ToString();
        }
    }
}