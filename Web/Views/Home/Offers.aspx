<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: Страны
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
	    $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageOffersId %>);
        });
    </script>
    <span class="mainTitle">
        <h1>Страны</h1>
    </span>
    <div class="colMain">
        <%  List<LinqToElcondor.TblCountryAll> list = ElcondorBiz.BizDictionary.GetCountryAllInfo();
            LinqToElcondor.TblCountryAll allRow = new LinqToElcondor.TblCountryAll();
            StringBuilder sb = new StringBuilder();
            
            sb.Append("<div class=\"dir_cols relover\"><div class=\"dir_col\"><ul>");
            foreach (int index in Elcondor.UI.Utilities.UIHelper.Divide3Columns(list.Count, 0)) {
                if (index > 0) {
                    if (list[index].RegionName != list[index - 1].RegionName)
                        sb.Append(string.Format("<h3>{0}</h3>", list[index].RegionName));
                } else {
                    sb.Append(string.Format("<h3>{0}</h3>", list[index].RegionName));
                }
                sb.Append("<li>");
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\"> ", list[index].Id));
                //sb.Append(string.Format(
                //                "<img src=\"../../Content/UserImages/flag_{0}.jpg\" alt=\"\" style=\"height: 30px;vertical-align: middle;\" /></a>&nbsp;", list[index].Id));
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">{1}</a> <i class=\"flag-top\" style=\"\"><img src=\"../../Content/UserImages/flag_{0}.jpg\" width=\"16px\" height=\"9px\" alt=\"\"/></i>", list[index].Id, list[index].RusName));
                sb.Append("</li>");
            }
            sb.Append("</ul></div>");
            sb.Append("<div class=\"dir_col\"><ul>");
            foreach (int index in Elcondor.UI.Utilities.UIHelper.Divide3Columns(list.Count, 1)) {
                if (list[index].RegionName != list[index - 1].RegionName)
                    sb.Append(string.Format("<h3>{0}</h3>", list[index].RegionName));
                sb.Append("<li>");
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">", list[index].Id));
                //sb.Append(string.Format(
                //                "<img src=\"../../Content/UserImages/flag_{0}.jpg\" alt=\"\" style=\"height: 30px;vertical-align: middle;\" /></a>&nbsp;", list[index].Id));
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">{1}</a> <i class=\"flag-top\" style=\"\"><img src=\"../../Content/UserImages/flag_{0}.jpg\" width=\"16px\" height=\"9px\" alt=\"\"/></i>", list[index].Id, list[index].RusName));
                sb.Append("</li>");
            }
            sb.Append("</ul></div>");
            sb.Append("<div class=\"dir_col\"><ul>");
            foreach (int index in Elcondor.UI.Utilities.UIHelper.Divide3Columns(list.Count, 2)) {
                if (list[index].RegionName != list[index - 1].RegionName)
                        sb.Append(string.Format("<h3>{0}</h3>", list[index].RegionName));
                sb.Append("<li>");
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">", list[index].Id));
                //sb.Append(string.Format(
                //                "<img src=\"../../Content/UserImages/flag_{0}.jpg\" alt=\"\" style=\"height: 30px;vertical-align: middle;\" /></a>&nbsp;", list[index].Id));
                sb.Append(string.Format("<a href=\"../../CountryAbout?id={0}\">{1}</a> <i class=\"flag-top\" style=\"\"><img src=\"../../Content/UserImages/flag_{0}.jpg\" width=\"16px\" height=\"9px\" alt=\"\"/></i>", list[index].Id, list[index].RusName));
                sb.Append("</li>");
            }
            sb.Append("</ul></div></div>");
            ViewData["CountryList"] = sb.ToString();
        %>
        <%= ViewData["CountryList"] %>
    </div>
    <div class="anchor"></div>
</asp:Content>
