<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Заметки путешественников
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <img src="../../Content/Images/greenarrow.png"/> Заметки путешественников
    </div>
    <h2>Заметки путешественников</h2>

</asp:Content>
