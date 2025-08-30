import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Wpad(
          child: ListConfig(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: displaySize.height * .04),
                      // --- All Users List from Firestore ---
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('All Registered Users', style: theme.textTheme.titleMedium),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Text('No users found.');
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            separatorBuilder: (context, i) => const Divider(),
                            itemBuilder: (context, i) {
                              final userData =
                                  snapshot.data!.docs[i].data() as Map<String, dynamic>;
                              return ListTile(
                                leading: userData['profileImage'] != null
                                    ? CircleAvatar(
                                        backgroundImage: MemoryImage(
                                          base64Decode(userData['profileImage']),
                                        ),
                                      )
                                    : const CircleAvatar(child: Icon(Icons.person)),
                                title: Text(userData['Username'] ?? 'No Name'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userData['Email'] ?? 'No Email'),
                                    Text(
                                      'Role: ${userData['Role'] ?? ''}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // --- End All Users List ---
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: displaySize.height * .4,
                    width: displaySize.width,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(displaySize.height * .02),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: List.generate(5, (index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: displaySize.height * .02),
                          Container(
                            height: displaySize.height * .1,
                            width: displaySize.width,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(displaySize.height * .02),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
