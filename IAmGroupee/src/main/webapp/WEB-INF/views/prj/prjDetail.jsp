<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.util.List"%>
<%@ page import="com.kh.iag.prj.entity.PrjReportDto"%>
<% 
	List<PrjReportDto> reportList = (List<PrjReportDto>)request.getAttribute("reportList");	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>prj_detail</title>

	<!-- Theme style -->
	<link rel="stylesheet" href="${root}/resources/dist/css/adminlte.css">
	<!-- Favicon -->
	<link rel="shortcut icon" href="${root}/resources/img/svg/looo.png" type="image/x-icon">
	<!-- adminLTE CDN -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.1/dist/css/adminlte.min.css">

	<!-- FullCalendar -->
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
	<script src="https://cdn.jsdelivr.net/npm/fullcalendar-scheduler@5.3.0/main.min.js"></script>

</head>
<body>
	
	<%@ include file="/WEB-INF/views/common/headerSide.jsp" %>
	 
	<main class="main">
	<div class="container">
		
		<section class="content-header">
        		<div class="container-fluid">
					<div class="row mb-2">
						<div class="col-sm-6">
							<h1>[&nbsp;${viewPrj.prjName}&nbsp;]</h1>
						</div>
						
						<div class="col-sm-6">
							<ol class="breadcrumb float-sm-right">
								<li class="breadcrumb-item"><a href="http://127.0.0.1:8989/iag/main">Home</a></li>
								<li class="breadcrumb-item active">Project Report</li>
							</ol>
						</div>
					</div> <!--/.row -->
				</div> <!--/.container-fluid -->
				<hr>
	    </section>
		
		
		<section class="content">
			<div class="container-fluid">
				<div class="row">

					<section class="col-lg-8 connectedSortable">
						<!-- reports -->
						<c:forEach items="${reportList}" var="r">
							<c:set var="t" value="${r.reportType}"/>
							<c:if test="${t eq 'G'}">
								<div class="card card-widget">
										<div class="card-header">
											<div class="row">
												<div class="col-lg-9">
													<h4>
														<span class="float-left badge bg-lightblue">??????</span>
														&nbsp;&nbsp;${r.reportName}
													</h4>
												</div>
		
												<div class="user-block col-lg-3">
												<!-- <img class="img-circle" src="${r.profile}" alt="user"> -->
												<span class="username">${r.name}</span>
												<span class="description">${r.createDate}</span>
												</div>
											</div>
										</div> <!-- /.card-header -->
			
										<div class="card-body">
											<br>
												${r.reportContent}
											<br>
										</div>
			
										<!-- /.card-body -->
										<div class="card-footer card-comments">
											<div class="card-comment">
												<!-- User image -->
												<img class="img-circle img-sm" src="" alt="user">
												<!-- /.comment-text -->
												<div class="comment-text">
													<span class="username">
													Maria Gonzales
													<span class="text-muted float-right"></span>
													</span><!-- /.username -->
													??????
												</div>
											</div>
										</div>
			
										<!-- /.card-footer -->
										<div class="card-footer">
											<!-- <img class="img-fluid img-circle img-sm" src="${loginUser.profile}" alt="Alt Text"> -->
											<!-- .img-push is used to add margin to elements next to floating images -->
											<div class="img-push">
												<div class="row">
													<div class="col-lg-11">
														<input type="text" class="form-control form-control-sm" id="content" placeholder="????????? ??????????????????.">
														<input style="display:none;" />
													</div>
													<div class="col-lg-1">
														<button type="button" class="btn btn-outline-primary btn-sm" onclick="comment();">??????</button>
													</div>
												</div>
												<input type="hidden" id="userNo" value="${loginUser.userNo}">
												<input type="hidden" id="reportNo" value="${r.reportNo}">
											</div>
										</div>
									</div>
							</c:if>

							<c:set var="t" value="${r.reportType}"/>
							<c:if test="${t eq 'C'}">
								<div class="card card-widget">
									<div class="card-header">
										<div class="row">
											<div class="col-lg-9">
												<h4>
													<span class="float-left badge bg-olive">??????</span>
													&nbsp;&nbsp;${r.reportName}
												</h4>
											</div>
	
											<div class="user-block col-lg-3">
											<!-- <img class="img-circle" src="${r.profile}" alt="user"> -->
											<span class="username">${r.name}</span>
											<span class="description">${r.createDate}</span>
											</div>
										</div>
									</div> <!-- /.card-header -->
		
									<div class="card-body">
										<br>
											<p>
												<h5><i class="fas fa-calendar-alt"></i>&nbsp;&nbsp;????????? ?????? : ${r.period}</h5>
												<br>
												<h5><i class="fas fa-map-marker-alt"></i>&nbsp;&nbsp;????????? ?????? : ${r.location}</h5>
												<hr>
											</p>
											<br>
											${r.reportContent}
										<br>
									</div>
		
									<!-- /.card-body -->
									<div class="card-footer card-comments">
										<div class="card-comment">
											<!-- User image -->
											<img class="img-circle img-sm" src="" alt="user">
											<!-- /.comment-text -->
											<div class="comment-text">
												<span class="username">
												Maria Gonzales
												<span class="text-muted float-right"></span>
												</span><!-- /.username -->
												??????
											</div>
										</div>
									</div>
		
									<!-- /.card-footer -->
									<div class="card-footer">
										<!-- <img class="img-fluid img-circle img-sm" src="${loginUser.profile}" alt="Alt Text"> -->
										<!-- .img-push is used to add margin to elements next to floating images -->
										<div class="img-push">
											<div class="row">
												<div class="col-lg-11">
													<input type="text" class="form-control form-control-sm" id="content" placeholder="????????? ??????????????????.">
													<input style="display:none;" />
												</div>
												<div class="col-lg-1">
													<button type="button" class="btn btn-outline-primary btn-sm" onclick="comment();">??????</button>
												</div>
											</div>
											<input type="hidden" id="userNo" value="${loginUser.userNo}">
											<input type="hidden" id="reportNo" value="${r.reportNo}">
										</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
					</section>  <!-- /. left row -->
				
					<section class="col-lg-4 connectedSortable">
						
						<!-- prj info -->
						<div class="card card-widget widget-user-2">
							<div class="card-header">
								<div class="btn-group btn-block">
									<button class="btn btn-primary disabled">??? ????????????</button>
									<button class="btn btn-outline-primary" data-toggle="modal" data-target="#noti">??????</button>
									<button class="btn btn-outline-primary" data-toggle="modal" data-target="#sch">??????</button>
									<button class="btn btn-outline-primary" data-toggle="modal" data-target="#work">??????</button>
								</div>
							</div>

							<div class="card-body">
								<strong><i class="fas fa-calendar-alt mr-1"></i> ???????????? ??????</strong>
								<p class="text-muted">${viewPrj.period}</p>
								<hr>
								<strong><i class="fas fa-users mr-1"></i> ?????? ??????</strong>
								<p class="text-muted">${viewPrj.departmentName}</p>
								<hr>
								<strong><i class="fas fa-user-cog"></i></i> ???????????? ?????????</strong>
								<p class="text-muted">${viewPrj.name}</p>
							</div>

							<div class="card-footer p-0">
							  <ul class="nav flex-column">
								<li class="nav-item">
									<a href="${root}/prj/prjDetail/${viewPrj.prjNo}" class="nav-link">
									  ???????????? <span class="float-right badge bg-primary">${allCnt}</span>
									</a>
								</li>
								<li class="nav-item">
								  <a href="${root}/prj/prjDetail/${viewPrj.prjNo}/G" class="nav-link">
									???????????? <span class="float-right badge bg-primary">${gCnt}</span>
								  </a>
								</li>
								<li class="nav-item">
								  <a href="${root}/prj/prjDetail/${viewPrj.prjNo}/C" class="nav-link">
									?????? <span class="float-right badge bg-primary">${cCnt}</span>
								  </a>
								</li>
								<li class="nav-item">
								  <a href="${root}/prj/prjDetail/${viewPrj.prjNo}/W" class="nav-link">
									??????????????? <span class="float-right badge bg-primary">${wCnt}</span>
								  </a>
								</li>
							  </ul>
							</div>
						</div>

						<!-- calendar -->
						<div class="card">
							<div class="card-header">
								<h3 class="card-title">??????</h3>
							</div>
							<div class="card-body">
								<div id="calendar"></div>
							</div>
						</div> <!-- /.card -->


					</section>

				</div> <!-- /.row -->
			</div> <!-- /.container-fluid -->
		</section> <!-- /.content-body -->
	</div>
	</main>    

	<!-- ??? ?????? ?????? -->
	<!-- ????????? -->
	<div class="modal fade" id="noti">
		<div class="modal-dialog modal-xl">
		<div class="modal-content">
			<div class="modal-header">
			  <h4 class="modal-title">??? ??????</h4>
			</div>
				<div class="modal-body">
					<div class="card-body">
						<div class="form-group">
							<label>??? ??????</label>
							<input type="text" class="form-control" id="reportName" placeholder="??? ????????? ???????????????." required>
							
							<input type="hidden" class="form-control" id="reportType" value="G">
							<input type="hidden" class="form-control" id="userNo" value="${loginUser.userNo}">
							<input type="hidden" class="form-control" id="prjNo" value="${viewPrj.prjNo}">
						</div>

						<textarea id="summernote" required></textarea>
					</div>
				</div> <!-- /.modal-body -->
				<div class="modal-footer justify-content-between">
					<input type="button" value="??????" class="btn btn-default" data-dismiss="modal">
					<button type="button" onclick="uploadNoti();" class="btn btn-primary">??????</button>
				</div>
		</div> <!-- /.modal-content -->
		</div> <!-- /.modal-dialog -->
	</div>

	<!-- ???????????? -->
	<div class="modal fade" id="sch">
		<div class="modal-dialog modal-xl">
		<div class="modal-content">
			<div class="modal-header">
			  <h4 class="modal-title">?????? ??????</h4>
			</div>
				<div class="modal-body">
					<div class="card-body">
						<div class="form-group">
							<label>??? ??????</label>
							<input type="text" class="form-control" id="reportNameS" placeholder="?????? ????????? ???????????????." required>
							<br>
							<label for="reservationtime">?????? & ??????</label>
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="far fa-clock"></i></span>
								</div>
								<input type="text" class="form-control float-right" id="reservationtime" required>
							</div>
							<br>
							<label>??????</label>
							<input type="text" class="form-control" id="location" placeholder="????????? ???????????????." required>

							<input type="hidden" class="form-control" id="reportTypeS" value="C">
							<input type="hidden" class="form-control" id="userNoS" value="${loginUser.userNo}">
							<input type="hidden" class="form-control" id="prjNoS" value="${viewPrj.prjNo}">
						</div>

						<textarea id="summernote1" required></textarea>
					</div>
				</div> <!-- /.modal-body -->
				<div class="modal-footer justify-content-between">
					<input type="button" value="??????" class="btn btn-default" data-dismiss="modal">
					<button type="button" onclick="uploadSch();" class="btn btn-primary">??????</button>
				</div>
		</div> <!-- /.modal-content -->
		</div> <!-- /.modal-dialog -->
	</div>

	<!-- ???????????? -->
	<div class="modal fade" id="work">
		<div class="modal-dialog modal-xl">
		<div class="modal-content">
			<div class="modal-header">
			  <h4 class="modal-title">?????? ??????</h4>
			</div>
				<div class="modal-body">
					<div class="card-body">
						<div class="form-group">
							<label>??? ??????</label>
							<input type="text" class="form-control" id="reportNameW" placeholder="??? ????????? ???????????????." required>
							
							<input type="hidden" class="form-control" id="reportTypeW" value="W">
							<input type="hidden" class="form-control" id="userNoW" value="${loginUser.userNo}">
							<input type="hidden" class="form-control" id="prjNoW" value="${viewPrj.prjNo}">
						</div>

						<textarea id="summernote2" required></textarea>
					</div>
				</div> <!-- /.modal-body -->
				<div class="modal-footer justify-content-between">
					<input type="button" value="??????" class="btn btn-default" data-dismiss="modal">
					<button type="button" onclick="uploadWork();" class="btn btn-primary">??????</button>
				</div>
		</div> <!-- /.modal-content -->
		</div> <!-- /.modal-dialog -->
	</div>
	<!-- modal ???! -->

	<script>
		
		$(function () {
					
			//summernote
			$("#summernote").summernote({
				dropdownParent: $('#noti'), //?????? ???????????? ??????
				lang: 'ko-KR',
				height: 300,  
				focus: true,
				placeholder : '????????? ???????????????',
				callbacks: {	//?????? ????????? ???????????? ???????????? ??????
					onImageUpload : function(files) {
						uploadSummernoteImageFile(files[0],this);
					},
					onPaste: function (e) {
						var clipboardData = e.originalEvent.clipboardData;
						if (clipboardData && clipboardData.items && clipboardData.items.length) {
							var item = clipboardData.items[0];
							if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
								e.preventDefault();
							}
						}
					}
				}	
			});
			
			$("#summernote1").summernote({
				dropdownParent: $('#sch'), //?????? ???????????? ??????
				lang: 'ko-KR',
				height: 300,  
				focus: true,
				placeholder : '????????? ???????????????',
				callbacks: {	//?????? ????????? ???????????? ???????????? ??????
					onImageUpload : function(files) {
						uploadSummernoteImageFile(files[0],this);
					},
					onPaste: function (e) {
						var clipboardData = e.originalEvent.clipboardData;
						if (clipboardData && clipboardData.items && clipboardData.items.length) {
							var item = clipboardData.items[0];
							if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
								e.preventDefault();
							}
						}
					}
				}
			});

			$("#summernote2").summernote({
				dropdownParent: $('#work'), //?????? ???????????? ??????
				lang: 'ko-KR',
				height: 300,  
				focus: true,
				placeholder : '????????? ???????????????',
				callbacks: {	//?????? ????????? ???????????? ???????????? ??????
					onImageUpload : function(files) {
						uploadSummernoteImageFile(files[0],this);
					},
					onPaste: function (e) {
						var clipboardData = e.originalEvent.clipboardData;
						if (clipboardData && clipboardData.items && clipboardData.items.length) {
							var item = clipboardData.items[0];
							if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
								e.preventDefault();
							}
						}
					}
				}
			});

			//????????? ?????? ?????????
			function uploadSummernoteImageFile(file, editor) {
				data = new FormData();
				data.append("file", file);
				$.ajax({
					data : data,
					type : "POST",
					url : "${root}/prj/file/${viewPrj.prjNo}",
					contentType : false,
					processData : false,
					success : function(data) {
						//?????? ???????????? ????????? url??? ????????? ??????.
						$(editor).summernote('insertImage', data.url);
					}
				});
			};	

			
		});

		function uploadNoti(){
			let param = {
				"reportName" : $('#reportName').val(),
				"reportType" : $('#reportType').val(),
				"reportContent" : $('#summernote').val(),
				"userNo" : $('#userNo').val(),
				"prjNo" : $('#prjNo').val(),
			}

			if(confirm("????????? ?????????????????????????") == true){
				$.ajax({
					type : 'POST',
					url : "${root}/prj/post",
					data : param,
					success : function(data){
						alert("?????? ??????????????? ?????????????????????.");
					},
					error : function(e){
						alert("??? ????????? ?????????????????????.");
					},
					complete : function(){
						window.location.reload();
					}
				});
			}else {
				return false;
			}
		}

		function uploadSch(){
			let param = {
				"reportName" : $('#reportNameS').val(),
				"reportType" : $('#reportTypeS').val(),
				"reportContent" : $('#summernote1').val(),
				"userNo" : $('#userNoS').val(),
				"prjNo" : $('#prjNoS').val(),
				"period" : $('#reservationtime').val(),
				"location" : $('#location').val()
			}
			if(confirm("????????? ?????????????????????????") == true){
				$.ajax({
					type : 'POST',
					url : "${root}/prj/postS",
					data : param,
					success : function(data){
						alert("????????? ??????????????? ?????????????????????.");
					},
					error : function(e){
						alert("?????? ????????? ?????????????????????.");
					},
					complete : function(){
						window.location.reload();
					}
				});
			}else {
				return false;
			}
		}

		function uploadWork(){
			let param = {
				"reportName" : $('#reportNameW').val(),
				"reportType" : $('#reportTypeW').val(),
				"reportContent" : $('#summernote2').val(),
				"userNo" : $('#userNoW').val(),
				"prjNo" : $('#prjNoW').val(),
			}

			if(confirm("????????? ?????????????????????????") == true){
				$.ajax({
					type : 'POST',
					url : "${root}/prj/postW",
					data : param,
					success : function(data){
						alert("????????? ??????????????? ?????????????????????.");
					},
					error : function(e){
						alert("?????? ????????? ?????????????????????.");
					},
					complete : function(){
						window.location.reload();
					}
				});
			}else {
				return false;
			}
		}

		function comment(){
			let param = {
				"reportNo" : $('#reportNo').val(),
				"content" : $('#content').val(),
				"userNo" : $('#userNo').val(),
			}
			$.ajax({
				type : 'POST',
				url : "${root}/prj/comm",
				data : param,
				success : function(){
					window.location.reload();
				},
				error : function(e){
					alert("?????? ????????? ?????????????????????.");
				}
			});
		}

		
		document.addEventListener('DOMContentLoaded', function() {
			var calendarEl = document.getElementById('calendar');
			var calendar = new FullCalendar.Calendar(calendarEl, {
				googleCalendarApiKey: 'AIzaSyAs1UZKO49dOGkrpX3qeYNU0wZx_vbq1Co',
				eventSources:{
					googleCalendarId: 'ko.south_korea#holiday@group.v.calendar.google.com',
					className: '??????????????? ??????',
					color : '#DD5246'
				},
				headerToolbar: {
					left: 'prev,next',
					center: 'title',
					right: 'dayGridMonth'
				},
				slotMinTime: '08:00', // Day ??????????????? ?????? ??????
				slotMaxTime: '20:00', // Day ??????????????? ?????? ??????
				initialView: 'dayGridMonth',
				navLinks: true, // ????????? ???????????? Day ???????????? Week ???????????? ??????
				selectable: true, // ?????? ?????? ????????? ????????????
				nowIndicator: true, // ?????? ?????? ??????
				dayMaxEvents: true, // ???????????? ???????????? ?????? ?????? (+ ??? ???????????? ??????)
				locale: 'ko', // ????????? ??????
				eventClick: function(info) {
					var start = moment(info.event.start).format("YYYY-MM-DD HH:mm");
					var end = moment(info.start).format("YYYY-MM-DD HH:mm");

					alert(info.event.title+' :::::::: ' + start + ' ~ '+ end);
				},
				events : 
				[ 
					<%if (reportList != null) {%>
						<%for (PrjReportDto r : reportList) {%>
							{
							title : '<%=r.getReportName()%>',
							start : '<%=r.getStartDate()%>',
							end : '<%=r.getEndDate()%>',
							color : '#2D82D7'
							},
						<%}
					}%>
				]
			});
			calendar.render();
	
		});

		$(function () {
			let today = new Date(); // ???????????? ?????? ??????.
			$('#reservationtime').daterangepicker({
			timePicker: true,
			timePickerIncrement: 10,
			timePicker24Hour: true,
			minDate: new Date(today),
			locale: {
				"separator": "~",               // ??????????????? ???????????? ?????????
				"format": 'YYYY-MM-DD HH:mm',     // ?????? ?????? ??????
				"applyLabel": "??????",              // ?????? ?????? ?????????
				"cancelLabel": "??????",             // ?????? ?????? ?????????
				"daysOfWeek": ["???", "???", "???", "???", "???", "???", "???"],
				"monthNames": ["1???", "2???", "3???", "4???", "5???", "6???", "7???", "8???", "9???", "10???", "11???", "12???"],
				}
    		})
		});

	</script>

	<%@ include file="/WEB-INF/views/common/footer.jsp" %>

	<!-- Custom scripts -->
	<script src="${root}/resources/js/script.js"></script>

	<!-- InputMask -->
	<script src="${root}/resources/plugins/moment/moment.min.js"></script>
	<script src="${root}/resources/plugins/inputmask/jquery.inputmask.min.js"></script>
		
	<!-- date-range-picker -->
	<link rel="stylesheet" href="${root}/resources/plugins/daterangepicker/daterangepicker.css">
	<script src="${root}/resources/plugins/daterangepicker/daterangepicker.js"></script> 
	
	<!-- Summernote -->
	<script src="${root}/resources/plugins/summernote/summernote-bs4.min.js"></script>	
	<link rel="stylesheet" href="${root}/resources/plugins/summernote/summernote-bs4.min.css">
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.js"></script>

	<!-- FullCalendar -->
	<link rel="stylesheet" href="${root}/resources/plugins/fullcalendar/main.css">

</body>
</html>