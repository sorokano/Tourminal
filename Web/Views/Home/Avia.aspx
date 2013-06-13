<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - <%= ViewData["PageTitle"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
	    $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageAviaId %>);
        });
    </script>
    <span class="mainTitle">
        <h1><%= ViewData["PageTitle"] %></h1>
    </span>
    <%= ViewData["PageContent"] %>
</asp:Content>
