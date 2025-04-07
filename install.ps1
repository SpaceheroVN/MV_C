# Script tự động cài đặt các phiên bản Visual C++ từ GitHub
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Tạo Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "SPVN"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

# Tiêu đề
$title = New-Object System.Windows.Forms.Label
$title.Text = "=========== Install selected versions of Microsoft Visual C++ ==========="
$title.Size = New-Object System.Drawing.Size(560, 30)
$title.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($title)

# Hướng dẫn chọn số bit
$question1 = New-Object System.Windows.Forms.Label
$question1.Text = "How many bits are you using Windows?"
$question1.Size = New-Object System.Drawing.Size(300, 30)
$question1.Location = New-Object System.Drawing.Point(20, 60)
$form.Controls.Add($question1)

# Checkbox cho x32
$checkbox32 = New-Object System.Windows.Forms.CheckBox
$checkbox32.Text = "x32"
$checkbox32.Location = New-Object System.Drawing.Point(20, 100)
$form.Controls.Add($checkbox32)

# Checkbox cho x64
$checkbox64 = New-Object System.Windows.Forms.CheckBox
$checkbox64.Text = "x64"
$checkbox64.Location = New-Object System.Drawing.Point(100, 100)
$form.Controls.Add($checkbox64)

# Hướng dẫn chọn phiên bản Visual C++
$question2 = New-Object System.Windows.Forms.Label
$question2.Text = "Select the Visual C++ versions to install:"
$question2.Size = New-Object System.Drawing.Size(300, 30)
$question2.Location = New-Object System.Drawing.Point(20, 140)
$form.Controls.Add($question2)

# Checkbox cho các phiên bản Visual C++
$versions = @("2005", "2008", "2010", "2012", "2013", "2015-2022")
$checkboxes = @()
$yOffset = 180
foreach ($version in $versions) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Text = $version
    $checkbox.Location = New-Object System.Drawing.Point(20, $yOffset)
    $form.Controls.Add($checkbox)
    $checkboxes += $checkbox
    $yOffset += 30
}

# Nút Install
$button = New-Object System.Windows.Forms.Button
$button.Text = "Install"
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Location = New-Object System.Drawing.Point(20, $yOffset)
$form.Controls.Add($button)

# Logic khi nhấn nút Install
$button.Add_Click({
    # Kiểm tra các lựa chọn
    $selectedVersions = @()
    foreach ($checkbox in $checkboxes) {
        if ($checkbox.Checked) {
            $selectedVersions += $checkbox.Text
        }
    }

    if ($selectedVersions.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select at least one version to install!", "SPVN")
        return
    }

    if (-not $checkbox32.Checked -and -not $checkbox64.Checked) {
        [System.Windows.Forms.MessageBox]::Show("Please select x32, x64, or both!", "SPVN")
        return
    }

    # Thực hiện cài đặt từ thư mục GitHub
    $baseUrl32 = "https://raw.githubusercontent.com/SpaceheroVN/MV_C/main/x32"
    $baseUrl64 = "https://raw.githubusercontent.com/SpaceheroVN/MV_C/main/x64"
    foreach ($version in $selectedVersions) {
        if ($checkbox32.Checked) {
            $fileUrl = "$baseUrl32/vcredist_$version_x32.exe"
            [System.Windows.Forms.MessageBox]::Show("Downloading and installing x32 version of Visual C++ $version...", "SPVN")
            Invoke-WebRequest -Uri $fileUrl -OutFile "vcredist_$version_x32.exe"
            Start-Process -FilePath "vcredist_$version_x32.exe" -ArgumentList "/quiet /norestart" -Wait
        }
        if ($checkbox64.Checked) {
            $fileUrl = "$baseUrl64/vcredist_$version_x64.exe"
            [System.Windows.Forms.MessageBox]::Show("Downloading and installing x64 version of Visual C++ $version...", "SPVN")
            Invoke-WebRequest -Uri $fileUrl -OutFile "vcredist_$version_x64.exe"
            Start-Process -FilePath "vcredist_$version_x64.exe" -ArgumentList "/quiet /norestart" -Wait
        }
    }

    [System.Windows.Forms.MessageBox]::Show("Installation completed!", "SPVN")
})

# Hiển thị Form
$form.ShowDialog()
