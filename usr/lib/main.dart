import 'package:flutter/material.dart';

void main() {
  runApp(const TechSpecApp());
}

class TechSpecApp extends StatelessWidget {
  const TechSpecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Specs Repository',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF263238), // Professional Blue-Grey
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FolderDashboardScreen(),
      },
    );
  }
}

// --- MOCK DATA ---

class TechSpec {
  final String id;
  final String title;
  final String version;
  final String lastUpdated;
  final String author;
  final String content;
  final IconData icon;

  TechSpec({
    required this.id,
    required this.title,
    required this.version,
    required this.lastUpdated,
    required this.author,
    required this.content,
    this.icon = Icons.description,
  });
}

final List<TechSpec> mockSpecs = [
  TechSpec(
    id: '1',
    title: 'API Gateway Architecture',
    version: 'v1.2.0',
    lastUpdated: 'Oct 24, 2023',
    author: 'Engineering Team',
    icon: Icons.api,
    content: '''# API Gateway Architecture

## Overview
This document outlines the technical specifications for the new API Gateway.

## Requirements
1. Rate limiting per tenant
2. JWT Authentication validation
3. Request/Response logging

## Endpoints
- `/api/v1/auth`
- `/api/v1/users`
- `/api/v1/specs`
''',
  ),
  TechSpec(
    id: '2',
    title: 'Database Schema v4',
    version: 'v4.0.1',
    lastUpdated: 'Nov 02, 2023',
    author: 'Data Team',
    icon: Icons.storage,
    content: '''# Database Schema v4

## Changes from v3
- Added `tenant_id` to all core tables for multi-tenancy.
- Migrated `user_preferences` to a JSONB column.

## Indexes
- B-Tree index on `tenant_id`
- GIN index on `user_preferences`
''',
  ),
  TechSpec(
    id: '3',
    title: 'Mobile App Security Guidelines',
    version: 'v2.1',
    lastUpdated: 'Nov 15, 2023',
    author: 'Security Team',
    icon: Icons.security,
    content: '''# Mobile App Security Guidelines

## Data Storage
- Never store plain-text passwords.
- Use secure enclave / keystore for sensitive tokens.

## Network
- Certificate pinning is required for all production builds.
- TLS 1.3 minimum.
''',
  ),
];

// --- SCREENS ---

class FolderDashboardScreen extends StatefulWidget {
  const FolderDashboardScreen({super.key});

  @override
  State<FolderDashboardScreen> createState() => _FolderDashboardScreenState();
}

class _FolderDashboardScreenState extends State<FolderDashboardScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSpecs = mockSpecs
        .where((spec) =>
            spec.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Shared Tech Specs', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            tooltip: 'Sync with Cloud',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing folders...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search specifications...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              
              // Folder Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Root Folder / Engineering',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Document List
              Expanded(
                child: filteredSpecs.isEmpty
                    ? const Center(child: Text('No specifications found.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: filteredSpecs.length,
                        itemBuilder: (context, index) {
                          final spec = filteredSpecs[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                child: Icon(
                                  spec.icon,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              title: Text(
                                spec.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        spec.version,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Updated: ${spec.lastUpdated}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.share),
                                color: Colors.blueGrey,
                                onPressed: () {
                                  _shareDocument(context, spec.title);
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocumentDetailScreen(spec: spec),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload new specification dialog would open here.')),
          );
        },
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Spec'),
      ),
    );
  }

  void _shareDocument(BuildContext context, String title) {
    // Mock sharing functionality
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Share "$title"', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Copy Web Link'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Web link copied to clipboard!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email to Team'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email draft opened.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class DocumentDetailScreen extends StatelessWidget {
  final TechSpec spec;

  const DocumentDetailScreen({super.key, required this.spec});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(spec.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading specification as PDF...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening share options...')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Document Header Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(spec.version),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  Text(
                    'Author: ${spec.author}',
                    style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const Divider(height: 32),
              
              // Document Content (Mocked Markdown-like rendering)
              Text(
                spec.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
