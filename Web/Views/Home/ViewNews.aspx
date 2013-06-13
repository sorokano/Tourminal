<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал <%= ViewData["NewsTitle"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#productheader").hide();
        });
    </script>
    <span class="mainTitle">
        <h1><%= ViewData["NewsTitle"] %></h1>
    </span>
    
    <%= Convert.ToBoolean(ViewData["NewsHasLargeImage"].ToString()) ? 
            string.Format(
                "<p><img src=\"../../Content/UserImages/news_{0}.jpg\" alt=\"{1}\" /></p>", ViewData["NewsId"], ViewData["NewsTitle"]) : string.Empty %>
    <%= ViewData["NewsDesc"]%>
    <div id="divdatechanged">Дата добавления: <%= ViewData["NewsDate"] %></div>
</asp:Content>
