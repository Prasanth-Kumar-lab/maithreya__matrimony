import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/UserProfile/view/UsersProfile.dart';
import 'package:matrimony/constants/constants.dart';
import '../../First Registration Process/widgets/profile_images_dialog.dart';
import '../controller/userProfile_controller.dart';
import '../model/userProfile_model.dart';

class MyProfileScreen extends StatelessWidget {
  final UserProfile user;

  const MyProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyProfileController(user));

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: AppColors.bgThemeColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.appBarIconColor),
        ),
      ),
      body: SafeArea(
        child: Obx(() => Container(
          color: AppColors.bgThemeColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(controller),
                 SizedBox(height: 0),
                _buildPhotosSection(controller),
                _buildBasicInfoSection(controller),
                _buildCasteInfoSection(controller),
                _buildLocationSection(controller),
                _buildEducationCareerSection(controller),
                _buildFamilySection(controller),
                _buildPreferencesSection(controller),
                _buildAdditionalInfoSection(controller),
                 SizedBox(height: 15),
                _buildActionButtons(controller),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildProfileHeader(MyProfileController controller) {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Obx(() => CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: controller.getBackgroundImage(),
                child: controller.showDefaultIcon
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              )),
              Positioned(
                bottom: -10,
                right: -10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Obx(() => IconButton(
                    icon: controller.isUpdating.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
                    )
                        : const Icon(Icons.camera_alt, color: Colors.blue, size: 20),
                    onPressed: controller.isUpdating.value ? null : controller.pickImage,
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Text(
            controller.getDisplayName(),
            style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          )),
        ],
      ),
    );
  }
  Widget _buildPhotosSection(MyProfileController controller) {
    final allPhotos = <String>[]..addAll(controller.serverPhotos);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Title + Icons Row (no Card) ----
          Obx(() {
            final hasNewPhotos = controller.selectedPhotos.isNotEmpty;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Photos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    // Always visible: Gallery & Camera
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_rounded, color: Colors.black),
                      onPressed: controller.pickMultipleImages,
                      tooltip: "Add from Gallery",
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera, color: Colors.black),
                      onPressed: controller.captureImage,
                      tooltip: "Take Photo",
                    ),

                    // Show only when new photos are selected
                    if (hasNewPhotos) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.close, color: AppColors.iconColor),
                        onPressed: () {
                          controller.selectedPhotos.clear();
                          controller.selectedPhotos.refresh();
                        },
                        tooltip: "Cancel",
                      ),
                      IconButton(
                        icon: controller.isUpdating.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          ),
                        )
                            : Icon(Icons.save, color: AppColors.iconColor),
                        onPressed:
                        controller.isUpdating.value ? null : controller.savePhotos,
                        tooltip: "Save Photos",
                      ),
                    ],
                  ],
                ),
              ],
            );
          }),
          // ---- Selected local photos (preview + remove) ----
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedPhotos.map((file) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.removeLocalPhoto(file),
                      child:CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black.withOpacity(0.8),
                        child: Icon(Icons.close, size: 16, color: AppColors.iconColor),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          )),

          // ---- Server photos (already uploaded) ----
          const SizedBox(height: 12),
          if (allPhotos.isEmpty && controller.selectedPhotos.isEmpty)
            const Center(
              child: Text("No photos yet", style: TextStyle(color: Colors.grey)),
            )
          else
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: allPhotos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () => showPhotoDialog(
                      context: context,
                      photos: allPhotos,
                      initialIndex: i,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        allPhotos[i],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required MyProfileController controller,
    required String title,
    required Widget viewContent,
    required Widget editContent,
    required VoidCallback onSave,
  }) {
    final isEditing = controller.editingSections.contains(title);
    return Card(
      color: AppColors.profileSectionCard,
      margin: EdgeInsets.symmetric(vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                if (!isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.indigo),
                    onPressed: () => controller.enterEditMode(title),
                  )
                else
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => controller.exitEditMode(title),
                      ),
                      Obx(() => IconButton(
                        icon: controller.isUpdating.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.green, strokeWidth: 2),
                        )
                            : const Icon(Icons.save, color: Colors.green),
                        onPressed: controller.isUpdating.value
                            ? null
                            : () async {
                          await Future.microtask(() => onSave());
                          if (!controller.isUpdating.value) {
                            controller.exitEditMode(title);
                          }
                        },
                      )),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 5),
            isEditing ? editContent : viewContent,
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(MyProfileController controller) {
    return _buildSectionCard(
      controller: controller,
      title: 'Basic Info',
      viewContent: _buildViewContent(controller, [
        _buildInfoRow("Number", controller.user.phone, Icons.phone),
        _buildInfoRow("Age", controller.user.age, Icons.cake),
        _buildInfoRow("Gender", controller.user.gender, Icons.person_outline),
        _buildInfoRow("Date of Birth", controller.user.dateOfBirth, Icons.calendar_today),
        _buildInfoRow("Marital Status", controller.user.maritalStatus, Icons.favorite_border),
        _buildInfoRow("Height", controller.user.height, Icons.height),
      ]),
      editContent: _buildEditContent(controller, [
        _buildEditableField("Name", controller.nameController, icon: Icons.person),
        _buildEditableField("Number", controller.phoneController, icon: Icons.phone),
        _buildEditableField("Gender", controller.genderController),
        _buildEditableField("Date of Birth", controller.dateOfBirthController),
        _buildEditableField("Age", controller.ageController),
        _buildEditableField("Marital Status", controller.maritalStatusController),
        _buildEditableField("Height", controller.heightController),
      ]),
      onSave: controller.saveBasicInfo,
    );
  }

  Widget _buildCasteInfoSection(MyProfileController controller) {
    return _buildSectionCard(
      controller: controller,
      title: 'Caste Info',
      viewContent: _buildViewContent(controller, [
        _buildInfoRow("Caste", controller.user.caste, Icons.person),
        _buildInfoRow("Sub-Caste", controller.user.subCaste, Icons.person),
      ]),
      editContent: _buildEditContent(controller, [
        _buildEditableField("Caste", controller.casteController, icon: Icons.person),
        _buildEditableField("Sub-Caste", controller.addressController, icon: Icons.person),
      ]),
      onSave: controller.saveBasicInfo,
    );
  }

  Widget _buildLocationSection(MyProfileController controller) {
    return _buildSectionCard(
      controller: controller,
      title: 'Location',
      viewContent: _buildViewContent(controller, [
        _buildInfoRow("Native Place", controller.user.nativePlace, Icons.home_outlined),
        _buildInfoRow("State", controller.user.stateName, Icons.map_outlined),
        _buildInfoRow("City", controller.user.city, Icons.location_city),
        _buildInfoRow("Address", controller.user.address, Icons.location_on),
      ]),
      editContent: _buildEditContent(controller, [
        _buildEditableField("Native Place", controller.nativePlaceController),
        _buildEditableField("State", controller.stateNameController),
        _buildEditableField("City", controller.cityController),
        _buildEditableField("Address", controller.addressController, maxLines: 3),
      ]),
      onSave: controller.saveLocation,
    );
  }

  Widget _buildEducationCareerSection(MyProfileController controller) {
    return _buildSectionCard(
      controller: controller,
      title: 'Education & Career',
      viewContent: _buildViewContent(controller, [
        _buildInfoRow("Education", controller.user.educationDetails, Icons.school),
        _buildInfoRow("Profession", controller.user.profession, Icons.work_outline),
        _buildInfoRow("Role", controller.user.role, Icons.badge_outlined),
        _buildInfoRow("Organization", controller.user.organization, Icons.apartment_outlined),
        _buildInfoRow("Income", controller.user.income, Icons.attach_money),
      ]),
      editContent: _buildEditContent(controller, [
        _buildEditableField("Education Details", controller.educationDetailsController, maxLines: 3),
        _buildEditableField("Profession", controller.professionController),
        _buildEditableField("Role", controller.roleController),
        _buildEditableField("Organization", controller.organizationController),
        _buildEditableField("Income", controller.incomeController),
      ]),
      onSave: controller.saveEducationCareer,
    );
  }

  Widget _buildFamilySection(MyProfileController controller) {
    return _buildSectionCard(
      controller: controller,
      title: 'Family',
      viewContent: _buildViewContent(controller, [
        _buildInfoRow("Mother's Name", controller.user.motherName, Icons.female),
        _buildInfoRow("Father's Name", controller.user.fatherName, Icons.male),
        _buildInfoRow("Brothers", controller.user.noOfBrothers, Icons.groups_2_outlined),
        _buildInfoRow("Sisters", controller.user.noOfSisters, Icons.groups_3_outlined),
      ]),
      editContent: _buildEditContent(controller, [
        _buildEditableField("Mother's Name", controller.motherNameController),
        _buildEditableField("Father's Name", controller.fatherNameController),
        _buildEditableField("No. of Sisters", controller.noOfSistersController),
        _buildEditableField("No. of Brothers", controller.noOfBrothersController),
      ]),
      onSave: controller.saveFamily,
    );
  }

  Widget _buildPreferencesSection(MyProfileController controller) {
    return _buildSectionCard(
      controller: controller,
      title: 'Preferences',
      viewContent: _buildViewContent(controller, [
        _buildInfoRow("Food Preference", controller.user.foodType, Icons.restaurant_menu),
        _buildInfoRow("Hobbies", controller.user.hobbies, Icons.palette_outlined),
        _buildInfoRow("Favourite Movies", controller.user.favouriteMovies, Icons.movie),
        _buildInfoRow("Favourite Books", controller.user.favouriteBooks, Icons.book),
        _buildInfoRow("Other Interests", controller.user.otherInterests, Icons.star_border),
      ]),
      editContent: _buildEditContent(controller, [
        _buildEditableField("Food Type", controller.foodTypeController),
        _buildEditableField("Hobbies", controller.hobbiesController, maxLines: 3),
        _buildEditableField("Favourite Movies", controller.favouriteMoviesController, maxLines: 3),
        _buildEditableField("Favourite Books", controller.favouriteBooksController, maxLines: 3),
        _buildEditableField("Other Interests", controller.otherInterestsController, maxLines: 3),
      ]),
      onSave: controller.savePreferences,
    );
  }

  Widget _buildAdditionalInfoSection(MyProfileController controller) {
    return _buildSectionCard(
      controller: controller,
      title: 'Additional Info',
      viewContent: _buildViewContent(controller, [
        _buildInfoRow("Birth Time", controller.user.birthTime, Icons.access_time),
        _buildInfoRow("About", controller.user.about, Icons.info_outline),
      ]),
      editContent: _buildEditContent(controller, [
        _buildEditableField("Birth Time", controller.birthTimeController),
        _buildEditableField("About", controller.aboutController, maxLines: 5),
      ]),
      onSave: controller.saveAdditionalInfo,
    );
  }

  Widget _buildActionButtons(MyProfileController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => controller.showLogoutConfirmationDialog(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 16),
        Obx(() => ElevatedButton(
          onPressed: controller.isDeleting.value ? null : controller.showDeleteConfirmationDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: controller.isDeleting.value
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
              : const Text('Delete Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        )),
      ],
    );
  }

  Widget _buildViewContent(MyProfileController controller, List<Widget> children) => Column(children: children);

  Widget _buildEditContent(MyProfileController controller, List<Widget> children) => Column(children: children);

  Widget _buildInfoRow(String label, String? value, IconData? icon) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2),
              child: Icon(icon, size: 20, color: Colors.indigo),
            ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, {IconData? icon, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          SizedBox(height: 4),
          TextFormField(
            controller: controller,
            minLines: 1,
            maxLines: maxLines,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon, size: 20, color: Colors.indigo) : null,
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo, width: 1.5)),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}