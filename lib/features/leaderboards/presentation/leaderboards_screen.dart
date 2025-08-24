import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../common/widgets/l2e_card.dart';
import '../../../common/widgets/empty_state.dart';
import '../providers/leaderboards_provider.dart';

class LeaderboardsScreen extends ConsumerStatefulWidget {
  const LeaderboardsScreen({super.key});

  @override
  ConsumerState<LeaderboardsScreen> createState() => _LeaderboardsScreenState();
}

class _LeaderboardsScreenState extends ConsumerState<LeaderboardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.leaderboards),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'All-time'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardTab('daily'),
          _buildLeaderboardTab('weekly'),
          _buildLeaderboardTab('monthly'),
          _buildLeaderboardTab('all-time'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(String boardId) {
    return Consumer(
      builder: (context, ref, child) {
        final leaderboardAsync = ref.watch(leaderboardProvider(boardId));
        final myPositionAsync = ref.watch(myLeaderboardPositionProvider(boardId));

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(leaderboardProvider(boardId));
            ref.invalidate(myLeaderboardPositionProvider(boardId));
          },
          child: Column(
            children: [
              myPositionAsync.when(
                data: (myPosition) => myPosition != null
                    ? Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: L2ECard(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                myPosition.rank.toString(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              'My Position',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(myPosition.displayName),
                            trailing: Text(
                              myPosition.metricValue.toStringAsFixed(0),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              Expanded(
                child: leaderboardAsync.when(
                  data: (entries) => entries.isEmpty
                      ? EmptyState(
                          icon: Icons.leaderboard,
                          title: 'No Leaderboard Data',
                          message: 'Check back later for leaderboard rankings.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: L2ECard(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _getRankColor(entry.rank),
                                    child: entry.rank <= 3
                                        ? Icon(
                                            _getRankIcon(entry.rank),
                                            color: Colors.white,
                                          )
                                        : Text(
                                            entry.rank.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                  title: Text(
                                    entry.displayName,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text('Rank #${entry.rank}'),
                                  trailing: Text(
                                    entry.metricValue.toStringAsFixed(0),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => EmptyState(
                    icon: Icons.error,
                    title: 'Error Loading Leaderboard',
                    message: 'Failed to load leaderboard: $error',
                    actionText: 'Retry',
                    onAction: () => ref.invalidate(leaderboardProvider(boardId)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.military_tech;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.person;
    }
  }
}
