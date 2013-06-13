using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.UI.Utilities {
    public static class GridTourListHelper {
        public static string GetTourGridHTML (List<TblTour> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GetHeader());
            foreach (TblTour itm in items) {
                bool hasImage = CheckHasImage(itm);
                sb.Append(GetFormattedRow(itm.Id.ToString(), itm.Name, hasImage, BizTour.GetTourRegionList(itm.Id)));
            }
            sb.Append(GetFooter());
            return sb.ToString();
        }

        private static bool CheckHasImage (TblTour itm) {
            bool hasImage = false;
            try {
                hasImage = itm.ThumbImage.Length > 0;
            } catch { hasImage = false; }
            return hasImage;
        }

        public static string GetExcursGridHTML (List<TblTour> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GetHeader());
            foreach (TblTour itm in items) {
                bool hasImage = CheckHasImage(itm);
                sb.Append(GetFormattedRow(itm.Id.ToString(), itm.Name, hasImage, BizTour.GetTourRegionList(itm.Id)));
            }
            sb.Append(GetFooter());
            return sb.ToString();
        }

        public static string GetCruiseGridHTML (List<TblTour> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GetHeader());
            foreach (TblTour itm in items) {
                bool hasImage = CheckHasImage(itm);
                sb.Append(GetFormattedRow(itm.Id.ToString(), itm.Name, hasImage, BizTour.GetTourRegionList(itm.Id)));
            }
            sb.Append(GetFooter());
            return sb.ToString();
        }

        public static string GetFormattedRow (string tourId, string tourName, bool hasImage, List<TblRegion> regs) {
            StringBuilder countryRegion = new StringBuilder();
            string regionNames = string.Empty;
            foreach (TblRegion itm in regs)
                countryRegion.Append(string.Format("{0}, ", itm.Name));
            if (countryRegion.Length > 0)
                regionNames = countryRegion.ToString().Substring(0, countryRegion.Length - 2);
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<tr>");
            //stringBuilder.Append("<td>");
            //stringBuilder.Append(tourId);
            //stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            if (hasImage)
                stringBuilder.Append(string.Format("<img alt=\"\" style=\"max-width:100px;max-height:80px;\" src=\"../../Content/UserImages/tour_th_{0}.jpg\">", tourId));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format("<a href=\"../../ViewTour?id={0}\">{1}</a>", tourId, tourName));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format("{0}", regionNames));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format("<a href=\"../../ViewTour?id={0}\">Подробнее...</a>", tourId));
            stringBuilder.Append("</td>");
            stringBuilder.Append("</tr>");
            return stringBuilder.ToString();
        }

        public static string GetHeader () {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<div>");
            stringBuilder.Append("<table style=\"width:750px;\">");
            stringBuilder.Append("    <thead>");
            stringBuilder.Append("    <tr>");
            //stringBuilder.Append("        <th scope=\"col\">");
            //stringBuilder.Append("            №");
            //stringBuilder.Append("        </th>");
            stringBuilder.Append("        <th scope=\"col\">");
            stringBuilder.Append("         &nbsp;   ");//image column
            stringBuilder.Append("        </th>");
            stringBuilder.Append("        <th scope=\"col\">");
            stringBuilder.Append(string.Format("{0}", "Название маршрута"));
            stringBuilder.Append("        </th>");
            stringBuilder.Append("        <th scope=\"col\" style=\"width:150px;\">");
            stringBuilder.Append(string.Format("{0}", "Регионы маршрута"));
            stringBuilder.Append("        </th>");
            stringBuilder.Append("        <th scope=\"col\">&nbsp;");
            //Подробнее button
            stringBuilder.Append("        </th>");
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
            stringBuilder.Append("</div>");
            return stringBuilder.ToString();
        }
    }
}