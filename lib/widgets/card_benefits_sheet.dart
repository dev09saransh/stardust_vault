import 'package:flutter/material.dart';
import 'glass_card.dart';
import '../utils/card_benefits.dart';
import '../theme.dart';
import 'package:animate_do/animate_do.dart';

class CardBenefitsSheet extends StatelessWidget {
  final String cardName;
  final String cardVariant;

  const CardBenefitsSheet({
    super.key,
    required this.cardName,
    required this.cardVariant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final benefits = CardBenefitsProvider.getBenefits(cardName, cardVariant);

    return GlassCard(
      margin: EdgeInsets.fromLTRB(
          AppSpacing.medium,
          100,
          AppSpacing.medium,
          MediaQuery.sizeOf(context).viewInsets.bottom + AppSpacing.xlarge),
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium - 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.credit_card_rounded, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cardName,
                        style: theme.textTheme.headlineSmall),
                    Text(cardVariant,
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Text('PREMIUM BENEFITS',
              style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: theme.colorScheme.primary)),
          const SizedBox(height: AppSpacing.medium),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: benefits.length,
              itemBuilder: (context, index) {
                final benefit = benefits[index];
                return FadeInRight(
                  delay: Duration(milliseconds: index * 100),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.small + 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(benefit.icon, size: 20, color: theme.colorScheme.onSurface),
                        ),
                        const SizedBox(width: AppSpacing.medium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(benefit.title,
                                  style: theme.textTheme.titleMedium),
                              const SizedBox(height: 2),
                              Text(benefit.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Center(
            child: Text(
              '* Verify benefits with your bank. Terms & conditions apply.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
