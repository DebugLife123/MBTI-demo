package com.mbti.training.servlet;

import com.mbti.training.dao.AdminDao;
import com.mbti.training.model.SysUser;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

@WebServlet("/exportExcel")
public class ExportExcelServlet extends HttpServlet {
    private AdminDao adminDao = new AdminDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 安全检查：确保只有管理员可以下载报表
        SysUser user = (SysUser) request.getSession().getAttribute("loginUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. 调取全网测试数据 (完美复用你在“测试概览”写好的查询方法)
        List<Map<String, Object>> logs = adminDao.getAllTestLogs();

        // 3. 在内存中创建一个 Excel 工作簿 (.xlsx 格式)
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("全网学生测评成绩表");

            // 4. 设置表头 (第一行)
            Row headerRow = sheet.createRow(0);
            String[] headers = {"序号", "用户名(账号)", "真实姓名", "测试时间", "性格类型", "维度得分明细"};

            // 给表头加粗一点样式
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // 5. 遍历数据库数据，填充到 Excel 行中
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            int rowNum = 1;
            for (Map<String, Object> log : logs) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(rowNum - 1); // 序号

                // 处理可能为 null 的字段，防止空指针异常
                row.createCell(1).setCellValue(log.get("username") != null ? log.get("username").toString() : "-");
                row.createCell(2).setCellValue(log.get("realName") != null ? log.get("realName").toString() : "-");

                Object testTimeObj = log.get("testTime");
                row.createCell(3).setCellValue(testTimeObj != null ? sdf.format((java.util.Date) testTimeObj) : "-");

                row.createCell(4).setCellValue(log.get("resultType") != null ? log.get("resultType").toString() : "-");
                row.createCell(5).setCellValue(log.get("scores") != null ? log.get("scores").toString() : "-");
            }

            // 自动调整一下列宽，让表格更好看
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // 🌟 6. 最关键的一步：设置 HTTP 响应头，告诉浏览器“这是一个要下载的文件”
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("utf-8");
            // 处理中文文件名乱码问题
            String fileName = URLEncoder.encode("MBTI学生测评成绩单", "UTF-8").replaceAll("\\+", "%20");
            response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

            // 7. 把 Excel 文件写入到网络输出流中，直接发给用户的浏览器
            OutputStream os = response.getOutputStream();
            workbook.write(os);
            os.flush();

        } catch (Exception e) {
            e.printStackTrace();
            // 如果报错了，弹窗提示
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<script>alert('系统异常，导出失败！请检查控制台日志。');history.back();</script>");
        }
    }
}