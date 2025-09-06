import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Screens/DashBoardScreens/HomePage.dart';
import '../../provider/job_provider.dart';
import '../../widget/customroundedappbar.dart';

class JobCreationPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController payFromController = TextEditingController();
  final TextEditingController payToController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController extraSkillsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF3949AB);
    final backgroundColor = Color(0xFFF5F7FA);
    final textColor = Color(0xFF2C3E50);
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: customRoundedAppBar(context, 'Post Job'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Location',
                  icon: Icons.location_on_outlined,
                  primaryColor: primaryColor,
                  controller: locationController,
                  onChanged: jobProvider.setLocation,
                  validator: (value) => value?.isEmpty ?? true ? 'Location is required' : null,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Department / Role Name',
                  icon: Icons.work_outline_rounded,
                  primaryColor: primaryColor,
                  controller: roleController,
                  onChanged: jobProvider.setRole,
                  validator: (value) => value?.isEmpty ?? true ? 'Role name is required' : null,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Education Level',
                  icon: Icons.school_outlined,
                  primaryColor: primaryColor,
                  controller: educationController,
                  onChanged: jobProvider.setEducationLevel,
                  validator: (value) => value?.isEmpty ?? true ? 'Education level is required' : null,
                ),
                SizedBox(height: 16),
                Text(
                  'Pay Scale',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'From',
                        icon: Icons.currency_rupee,
                        primaryColor: primaryColor,
                        controller: payFromController,
                        onChanged: jobProvider.setPayFrom,
                        validator: (value) => value?.isEmpty ?? true ? 'Minimum pay is required' : null,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'To',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildTextField(
                        label: 'To',
                        icon: Icons.currency_rupee,
                        primaryColor: primaryColor,
                        controller: payToController,
                        onChanged: jobProvider.setPayTo,
                        validator: (value) => value?.isEmpty ?? true ? 'Maximum pay is required' : null,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                  child: Row(
                    children: [
                      Text(
                        'Display This',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: true,
                                  groupValue: jobProvider.displayThis,
                                  activeColor: primaryColor,
                                  onChanged: (value) => jobProvider.setDisplayThis(value as bool),
                                ),
                                Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            Row(
                              children: [
                                Radio(
                                  value: false,
                                  groupValue: jobProvider.displayThis,
                                  activeColor: primaryColor,
                                  onChanged: (value) => jobProvider.setDisplayThis(value as bool),
                                ),
                                Text(
                                  'No',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Extra Skills / Requirements',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: requirementsController,
                  maxLines: 2,
                  onChanged: jobProvider.setRequirements,
                  validator: (value) => value?.isEmpty ?? true ? 'Requirements are required' : null,
                  decoration: InputDecoration(
                    hintText: 'Enter job requirements...',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Job Description',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Add file functionality here
                      },
                      child: Row(
                        children: [
                          Text(
                            'Add File',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.attach_file,
                            color: Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: extraSkillsController,
                  maxLines: 4,
                  onChanged: jobProvider.setExtraSkills,
                  validator: (value) => value?.isEmpty ?? true ? 'Extra skills are required' : null,
                  decoration: InputDecoration(
                    hintText: 'Enter additional skills required...',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final validationError = jobProvider.validateFields();
                            if (validationError != null) {
                              Fluttertoast.showToast(
                                msg: validationError,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }

                            final success = await jobProvider.saveJob();
                            if (success) {
                              Fluttertoast.showToast(
                                msg: "Job posted successfully!",
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );
                              // Clear all fields
                              jobProvider.clearFields();
                              locationController.clear();
                              roleController.clear();
                              educationController.clear();
                              payFromController.clear();
                              payToController.clear();
                              requirementsController.clear();
                              extraSkillsController.clear();

                              // Navigate to home screen
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                                (route) => false,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "Failed to post job. Please try again.",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Color primaryColor,
    required TextEditingController controller,
    required Function(String) onChanged,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          color: Colors.grey[600],
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
