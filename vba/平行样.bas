Attribute VB_Name = "平行样"




'批量生成平行样
'1 氨氮
'2 总氮
'3 氨
'4 氟化物 水
'

Sub all_pallas()
Attribute all_pallas.VB_ProcData.VB_Invoke_Func = "b\n14"
    Dim cr As Integer           '当前行
    Dim head As Integer         '开始行
    Dim tail As Integer         '结束行
    Dim fn   As String          'filename
    Dim proj As Integer
    
    fn = ActiveWorkbook.Name
    'Cells(35, 1).Value = fn
    
    'InStr(1, fn, "氨氮")
    
    If InStr(1, fn, "氨氮") > 0 Then
        proj = 1
    ElseIf InStr(1, fn, "总氮") > 0 Then
        proj = 2
    ElseIf InStr(1, fn, "氨") > 0 Then
        proj = 3
    ElseIf InStr(1, fn, "氟化物") > 0 Then
        proj = 4
    End If
        
    head = Selection.row()
    tail = head + 2 * Selection.rows.Count - 1
    
    '遍历
    For cr = head To tail Step 2
        Call palla(cr, proj)
    Next cr
    
    
   
End Sub



Private Sub palla(r As Integer, proj As Integer)
'
' r 是当前操作的行数
' 快捷键: Ctrl+p
'
    Dim datst As Integer        '数据区域列开始
    Dim dated As Integer        '数据区域列结束
    Dim asb   As Integer        '吸光度列
    Dim factor As Integer       '稀释度列
    Dim blank  As Integer       '空白
   
   
   If proj = 1 Then                 'ad
        datst = 8
        dated = 16
        asb = 8
        blank = 9
        factor = 11
   ElseIf proj = 2 Then             'zd
        datst = 8
        dated = 19
        asb = 14
        blank = 13
        factor = 8
   ElseIf proj = 3 Then             'a
        datst = 7
        dated = 16
        blank = 8
        asb = 7
   ElseIf proj = 4 Then             'fwh water
        datst = 7
        dated = 12
        ' 氟化物是电位值
        asb = 10
        factor = 9
   End If
   
   
  ' Cells(40, 2).Value = datst
   'Cells(40, 3).Value = dated
    
    '插入
    rows(r + 1 & ":" & r + 1).Select
    Selection.Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove
    
    '填充标记、编号
    Cells(r, 3) = Cells(r, 3).Value & "-1"
    
    Range(Cells(r, 1), Cells(r, 3)).Select
    Selection.AutoFill Destination:=Range(Cells(r, 1), Cells(r + 1, 3)), Type:=xlFillDefault
   
   '选中数据区域
    Range(Cells(r, datst), Cells(r, dated)).Select
    Selection.AutoFill Destination:=Range(Cells(r, datst), Cells(r + 1, dated)), Type:=xlFillDefault
    
    '修改吸光度
    Cells(r + 1, asb).Select
    If proj <> 4 Then
        ActiveCell.FormulaR1C1 = "=R[-1]C-0.001"
    Else
        ActiveCell.FormulaR1C1 = "=R[-1]C+0.9"
    End If
    
    '修改空白
    If proj <> 4 Then
        Cells(r + 1, blank).Select
        ActiveCell.FormulaR1C1 = "=R[-1]C"
    End If
    
    '修改稀释浓度
    If proj <> 3 Then
        Cells(r + 1, factor).Select
        ActiveCell.FormulaR1C1 = "=R[-1]C"
    End If
End Sub


















