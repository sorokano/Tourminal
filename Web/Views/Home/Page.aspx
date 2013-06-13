<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData["PageTitle"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
            $(".book").click(function () {                
                $('#lblTourname').text('<%= ViewData["TourName"] %>');
                $('#itemId').val('<%= ViewData["TourId"] %>');
                $('#itemName').val('<%= ViewData["TourName"] %>');
                $('#txtDlgItemName').val("");
                $('#dialog-book').dialog('open');
				$("#datefrom").datepicker($.datepicker.regional['ru']);
				$("#dateto").datepicker($.datepicker.regional['ru']);
				return false;
            });
			
			$("#dialog-book").dialog({
                autoOpen: false,
                resizable: false,
                height: 640,
                width: 720,
                modal: true,
                title: 'Подтвердите бронирование',
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                    }
                },
                close: function () {
                    //$('#txtDlgItemId').val("");
                    //$('#txtDlgTagSize').val("");
                    //location.reload();
                }
            });
			hideshow('loading', 0);
		});
    </script>
	
	<h3><%= ViewData["PageTitle"] %></h3>
    <%= ViewData["PageContent"] %>
	
	<div id="dialog-book">
        <form method="post" id="msgForm" style="margin: 0 auto;" action="../../verifyRegistration.php">
        <h2>
            <label id="lblTourname">
            </label>
        </h2>
        <div id="errorContact" class="error">&nbsp;</div>
        <table class="tblsimple">
            <tr>
                <td>
                    Ваше имя:
                </td>
                <td>
                    <div class="input-container">
                        <input name="nameContact" id="nameContact" type="text" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Ваш контактный Email:
                </td>
                <td>
                    <div class="input-container">
                        <input name="emailContact" id="emailContact" type="text" />
                    </div>
                </td>
            </tr>
			
            <tr>
                <td>
                    Предполагаемые даты поездки:
                </td>
                <td>
                    с
                    <%= Html.TextBox("datefrom", string.Empty, new { style = "width:100px" })%>
                    по
                    <%= Html.TextBox("dateto", string.Empty, new { style = "width:100px" })%>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span style="color: #000; margin-bottom: 5px;">Присоединить сообщение:</span><br />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="input-container">
                        <textarea name="contentContact" id="contentContact" rows="5" cols="70"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span style="color: #000; margin-bottom: 5px;">Введите текст на картинке:</span><br />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="captchaitm">
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" id="btnsubmit"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="float: right;" value="Отправить" />
                    <img id="loading" src="../../Content/Images/ajax-wait.gif" alt="working.." style="float: right;
                        margin-right: 5px; padding-top: 2px;" />
                </td>
            </tr>
        </table>
        <input name="itemId" id="itemId" type="text" style="display: none;" />
        <input name="itemName" id="itemName" type="text" style="display: none;" />
        
        
        </form>
        
    </div>
</asp:Content>