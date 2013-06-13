<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Личный кабинет
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
	    $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageUserHomeId %>);
        });
    </script>
    <span class="mainTitle">
        <h1 class="section" id="sectionTitle">Личный кабинет</h1>
    </span>

</asp:Content>
