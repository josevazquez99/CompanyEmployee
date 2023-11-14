<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.mysql.cj.x.protobuf.MysqlxDatatypes.Array"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.jacaranda.model.EmployeeProject"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.chrono.ChronoLocalDateTime"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.Date"%>
<%@page import="com.jacaranda.model.CompanyProject"%>
<%@page import="com.jacaranda.model.Project"%>
<%@page import="com.jacaranda.model.Employee"%>
<%@page import="com.jacaranda.model.User"%>
<%@page import="com.jacaranda.repository.DbRepository"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add hours multiple projects</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
	<%if(session.getAttribute("employee") != null){ %>
		

		<%Map<Integer,LocalDateTime> mapProject = session.getAttribute("mapaProject") != null 
													? (HashMap<Integer,LocalDateTime>) session.getAttribute("mapaProject") 
															: new HashMap<Integer,LocalDateTime>();
		

	    if(request.getParameter("start") != null){
	  	  try{		    		  
	  	  	mapProject.put(Integer.valueOf(request.getParameter("start")), LocalDateTime.now());
	  	  	session.setAttribute("mapaProject", mapProject);
	  	  }catch(Exception ex){
	  		  response.sendRedirect("error="+ex.getMessage());
	  	  }
  	  	
  	  	
	    }else if(request.getParameter("stop") != null){
	   	  	try{		    	
	   	  		
	   	  		Project p = null;
	   	  		
	   	  		try{
	   	  			p = DbRepository.find(Project.class, Integer.valueOf(request.getParameter("stop")));
	   	  		}catch(Exception ex1){
		   	  		  response.sendRedirect("error="+ex1.getMessage());
	   	  		}
	       		
	   	  		int seconds = 0;
	   	  		try{
	   	  			seconds = (int) ChronoUnit.SECONDS.between(mapProject.get(Integer.valueOf(request.getParameter("stop"))), 
							LocalDateTime.now());
	   	  		}catch(Exception ex2){
		   	  		  response.sendRedirect("error="+ex2.getMessage());
	   	  		}
	   	  		
	   	  		EmployeeProject ep = new EmployeeProject(p,((Employee)session.getAttribute("employee")),seconds);
	   	  		
	        	if(DbRepository.find(ep) != null){
	        		ep.setMinute(DbRepository.find(ep).getMinute()+seconds);
	        		DbRepository.editEntity(ep);
	        	}else{
	         		DbRepository.addEntity(ep);
	        	}
	   	  		
	   	  	  	mapProject.remove(Integer.valueOf(request.getParameter("stop")));
	   	  	  	session.setAttribute("mapaProject", mapProject);
	   	 	}catch(Exception ex){
	   	  		  response.sendRedirect("error="+ex.getMessage());
	   	  	  }
	    }
	
	%>
	<%@include file="nav.jsp" %>

		          <div class="h1 fw-light">Add hours multiple projects</div>
		          <br>
		          <form>
		            <div class="form-floating mb-3">
						<label for="projects" class="form-label">Project's</label><br>
							<table class="table">
							<%
								Employee e = (Employee) session.getAttribute("employee");
								for (CompanyProject cp : e.getCompany().getCompanyProject()){
									if(cp.getEnd().after(Date.valueOf(LocalDate.now()))){ //Aqui compruebo que el proyecto está activo y lo muestro%>
									<tr>
										<td><%=cp.getProject().getName()%></td>
										<%if(!mapProject.containsKey(cp.getProject().getId())){ %>
											<td><button class="btn btn-primary" type="submit" value="<%=cp.getProject().getId()%>" name="start">Empezar a trabajar</button></td>  		
										<%}else{%>
											<td><button class="btn btn-danger" type="submit" value="<%=cp.getProject().getId()%>" name="stop">Dejar de trabajar</button></td>  													
										<%}%>
									</tr>
									<%}%>
								<%}%>
							</table>
		            </div>		          

         		   <button class="btn btn-info btn-ms mt-2" id="nameE" value="nameE" type="button" name="nameE"><%=((Employee)session.getAttribute("employee")).getFirstName()%></button>
		         </form>

		<%}else{ 
			response.sendRedirect("./login.jsp");
			return;
		}%>
</body>
</html>