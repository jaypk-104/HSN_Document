namespace NTS_Reader_CS
{
    partial class NTS_Reader
    {
        /// <summary>
        /// 필수 디자이너 변수입니다.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 사용 중인 모든 리소스를 정리합니다.
        /// </summary>
        /// <param name="disposing">관리되는 리소스를 삭제해야 하면 true이고, 그렇지 않으면 false입니다.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form 디자이너에서 생성한 코드

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            this.grpPdf = new System.Windows.Forms.GroupBox();
            this.btnPdf = new System.Windows.Forms.Button();
            this.txtPdf = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.txtPass = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.grpButton = new System.Windows.Forms.GroupBox();
            this.button1 = new System.Windows.Forms.Button();
            this.btnEuckr = new System.Windows.Forms.Button();
            this.btnUtf8 = new System.Windows.Forms.Button();
            this.btnVerify = new System.Windows.Forms.Button();
            this.grpEuckr = new System.Windows.Forms.GroupBox();
            this.txtEuckr = new System.Windows.Forms.RichTextBox();
            this.grpUtf8 = new System.Windows.Forms.GroupBox();
            this.txtUtf8 = new System.Windows.Forms.RichTextBox();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.EMP_NO = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.NAME = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.FILE_PATH = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.grpPdf.SuspendLayout();
            this.grpButton.SuspendLayout();
            this.grpEuckr.SuspendLayout();
            this.grpUtf8.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // grpPdf
            // 
            this.grpPdf.Controls.Add(this.btnPdf);
            this.grpPdf.Controls.Add(this.txtPdf);
            this.grpPdf.Controls.Add(this.button1);
            this.grpPdf.Controls.Add(this.label1);
            this.grpPdf.Location = new System.Drawing.Point(12, 54);
            this.grpPdf.Name = "grpPdf";
            this.grpPdf.Size = new System.Drawing.Size(642, 63);
            this.grpPdf.TabIndex = 0;
            this.grpPdf.TabStop = false;
            // 
            // btnPdf
            // 
            this.btnPdf.Location = new System.Drawing.Point(319, 23);
            this.btnPdf.Name = "btnPdf";
            this.btnPdf.Size = new System.Drawing.Size(85, 23);
            this.btnPdf.TabIndex = 2;
            this.btnPdf.Text = "폴더 찾기...";
            this.btnPdf.UseVisualStyleBackColor = true;
            this.btnPdf.Click += new System.EventHandler(this.btnPdf_Click);
            // 
            // txtPdf
            // 
            this.txtPdf.Location = new System.Drawing.Point(93, 23);
            this.txtPdf.Name = "txtPdf";
            this.txtPdf.Size = new System.Drawing.Size(218, 21);
            this.txtPdf.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(19, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(68, 12);
            this.label1.TabIndex = 0;
            this.label1.Text = "PDF 폴더 : ";
            // 
            // txtPass
            // 
            this.txtPass.Location = new System.Drawing.Point(264, 34);
            this.txtPass.Name = "txtPass";
            this.txtPass.Size = new System.Drawing.Size(119, 21);
            this.txtPass.TabIndex = 4;
            this.txtPass.Visible = false;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(274, 19);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(88, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "PDF 비밀번호 :";
            this.label2.Visible = false;
            // 
            // grpButton
            // 
            this.grpButton.Controls.Add(this.label2);
            this.grpButton.Controls.Add(this.txtPass);
            this.grpButton.Controls.Add(this.btnEuckr);
            this.grpButton.Controls.Add(this.btnUtf8);
            this.grpButton.Controls.Add(this.btnVerify);
            this.grpButton.Location = new System.Drawing.Point(12, 431);
            this.grpButton.Name = "grpButton";
            this.grpButton.Size = new System.Drawing.Size(818, 63);
            this.grpButton.TabIndex = 1;
            this.grpButton.TabStop = false;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(440, 10);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(190, 47);
            this.button1.TabIndex = 3;
            this.button1.Text = "연말정산반영";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // btnEuckr
            // 
            this.btnEuckr.Location = new System.Drawing.Point(677, 20);
            this.btnEuckr.Name = "btnEuckr";
            this.btnEuckr.Size = new System.Drawing.Size(138, 37);
            this.btnEuckr.TabIndex = 2;
            this.btnEuckr.Text = "XML 읽기 (EUC-KR)";
            this.btnEuckr.UseVisualStyleBackColor = true;
            this.btnEuckr.Visible = false;
            this.btnEuckr.Click += new System.EventHandler(this.btnEuckr_Click);
            // 
            // btnUtf8
            // 
            this.btnUtf8.Location = new System.Drawing.Point(533, 20);
            this.btnUtf8.Name = "btnUtf8";
            this.btnUtf8.Size = new System.Drawing.Size(138, 37);
            this.btnUtf8.TabIndex = 1;
            this.btnUtf8.Text = "XML 읽기 (UTF-8)";
            this.btnUtf8.UseVisualStyleBackColor = true;
            this.btnUtf8.Visible = false;
            this.btnUtf8.Click += new System.EventHandler(this.btnUtf8_Click);
            // 
            // btnVerify
            // 
            this.btnVerify.Location = new System.Drawing.Point(389, 20);
            this.btnVerify.Name = "btnVerify";
            this.btnVerify.Size = new System.Drawing.Size(138, 37);
            this.btnVerify.TabIndex = 0;
            this.btnVerify.Text = "원본검증";
            this.btnVerify.UseVisualStyleBackColor = true;
            this.btnVerify.Visible = false;
            this.btnVerify.Click += new System.EventHandler(this.btnVerify_Click);
            // 
            // grpEuckr
            // 
            this.grpEuckr.Controls.Add(this.txtEuckr);
            this.grpEuckr.Location = new System.Drawing.Point(424, 500);
            this.grpEuckr.Name = "grpEuckr";
            this.grpEuckr.Size = new System.Drawing.Size(406, 96);
            this.grpEuckr.TabIndex = 1;
            this.grpEuckr.TabStop = false;
            this.grpEuckr.Text = "XML (EUC-KR)";
            // 
            // txtEuckr
            // 
            this.txtEuckr.BackColor = System.Drawing.SystemColors.Window;
            this.txtEuckr.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.txtEuckr.Font = new System.Drawing.Font("굴림", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.txtEuckr.Location = new System.Drawing.Point(6, 20);
            this.txtEuckr.Name = "txtEuckr";
            this.txtEuckr.ReadOnly = true;
            this.txtEuckr.Size = new System.Drawing.Size(394, 68);
            this.txtEuckr.TabIndex = 0;
            this.txtEuckr.Text = "";
            // 
            // grpUtf8
            // 
            this.grpUtf8.Controls.Add(this.txtUtf8);
            this.grpUtf8.Location = new System.Drawing.Point(12, 500);
            this.grpUtf8.Name = "grpUtf8";
            this.grpUtf8.Size = new System.Drawing.Size(406, 96);
            this.grpUtf8.TabIndex = 1;
            this.grpUtf8.TabStop = false;
            this.grpUtf8.Text = "XML (UTF-8)";
            // 
            // txtUtf8
            // 
            this.txtUtf8.BackColor = System.Drawing.SystemColors.Window;
            this.txtUtf8.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.txtUtf8.Font = new System.Drawing.Font("굴림", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.txtUtf8.Location = new System.Drawing.Point(6, 20);
            this.txtUtf8.Name = "txtUtf8";
            this.txtUtf8.ReadOnly = true;
            this.txtUtf8.Size = new System.Drawing.Size(394, 68);
            this.txtUtf8.TabIndex = 0;
            this.txtUtf8.Text = "";
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            dataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle4.Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            dataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dataGridView1.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle4;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.EMP_NO,
            this.NAME,
            this.FILE_PATH});
            this.dataGridView1.EnableHeadersVisualStyles = false;
            this.dataGridView1.Location = new System.Drawing.Point(12, 121);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.RowTemplate.Height = 23;
            this.dataGridView1.Size = new System.Drawing.Size(643, 263);
            this.dataGridView1.TabIndex = 3;
            this.dataGridView1.KeyUp += new System.Windows.Forms.KeyEventHandler(this.dataGridView1_KeyUp);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("굴림", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.label3.ForeColor = System.Drawing.Color.Red;
            this.label3.Location = new System.Drawing.Point(13, 6);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(312, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "연말정산 부양가족공제자 등록 선행후 작하세요.";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("굴림", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.label4.ForeColor = System.Drawing.Color.Red;
            this.label4.Location = new System.Drawing.Point(12, 24);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(420, 13);
            this.label4.TabIndex = 4;
            this.label4.Text = "연말정산 부양가족공제자 등록에 없는 인원은 사용할수 없습니다.";
            // 
            // EMP_NO
            // 
            this.EMP_NO.DataPropertyName = "EMP_NO";
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            this.EMP_NO.DefaultCellStyle = dataGridViewCellStyle5;
            this.EMP_NO.Frozen = true;
            this.EMP_NO.HeaderText = "사번";
            this.EMP_NO.Name = "EMP_NO";
            this.EMP_NO.ReadOnly = true;
            // 
            // NAME
            // 
            this.NAME.DataPropertyName = "NAME";
            this.NAME.HeaderText = "성명";
            this.NAME.Name = "NAME";
            this.NAME.ReadOnly = true;
            // 
            // FILE_PATH
            // 
            this.FILE_PATH.DataPropertyName = "FILE_PATH";
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            this.FILE_PATH.DefaultCellStyle = dataGridViewCellStyle6;
            this.FILE_PATH.HeaderText = "파일경로";
            this.FILE_PATH.Name = "FILE_PATH";
            this.FILE_PATH.ReadOnly = true;
            this.FILE_PATH.Width = 400;
            // 
            // NTS_Reader
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(664, 390);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.grpButton);
            this.Controls.Add(this.grpEuckr);
            this.Controls.Add(this.grpUtf8);
            this.Controls.Add(this.grpPdf);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "NTS_Reader";
            this.ShowIcon = false;
            this.Text = "NTS_Reader";
            this.Load += new System.EventHandler(this.NTS_Reader_Load);
            this.grpPdf.ResumeLayout(false);
            this.grpPdf.PerformLayout();
            this.grpButton.ResumeLayout(false);
            this.grpButton.PerformLayout();
            this.grpEuckr.ResumeLayout(false);
            this.grpUtf8.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.GroupBox grpPdf;
        private System.Windows.Forms.GroupBox grpButton;
        private System.Windows.Forms.GroupBox grpEuckr;
        private System.Windows.Forms.GroupBox grpUtf8;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btnPdf;
        private System.Windows.Forms.TextBox txtPdf;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnEuckr;
        private System.Windows.Forms.Button btnUtf8;
        private System.Windows.Forms.Button btnVerify;
        private System.Windows.Forms.TextBox txtPass;
        private System.Windows.Forms.RichTextBox txtUtf8;
        private System.Windows.Forms.RichTextBox txtEuckr;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.DataGridViewTextBoxColumn EMP_NO;
        private System.Windows.Forms.DataGridViewTextBoxColumn NAME;
        private System.Windows.Forms.DataGridViewTextBoxColumn FILE_PATH;
    }
}

