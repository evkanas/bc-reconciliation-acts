# Portfolio Neutralization Report

Date: 2026-06-11

## Scope

The project was converted into a neutral public portfolio sample while preserving the executable reconciliation-statement logic as far as possible.

## Changes

- Replaced the original organization-specific affix with the neutral `EVK` affix in AL objects, symbols, variables, fields, enum values, report datasets, RDLC layouts, Word layout XML, translations, filenames, and metadata.
- Preserved the author's portfolio publisher and GitHub profile while generating a new application UUID.
- Renamed the application to `Reconciliation Statements Portfolio` and generalized its description.
- Reset the application version to `1.0.0.0`.
- Moved custom object, extension-field, and enum-value IDs from the original `500xx`/`800xx` values into the neutral `70100..70199` portfolio range.
- Updated `AppSourceCop.json` to require the `ReconcilStatementLine` affix.
- Renamed all custom AL objects so they comply with the configured affix.
- Updated English and Lithuanian XLF content and generator notes for renamed objects.
- Removed source comments, internal numeric annotations, commented-out Code, and informal implementation notes.
- Preserved the author's personal portfolio avatar and its `logo` property in `app.json`.
- Removed a stale `extensionsPermissionSet.xml` artifact that referenced unrelated objects outside the project.
- Removed unused duplicate report layouts named `Copy` and an unreferenced standard layout.
- Rebuilt the Word report package after neutralizing its internal custom XML namespace and dataset element names.
- Replaced the README with portfolio-oriented documentation and a production-use disclaimer.

## Dependencies And Data

- Retained only the standard Microsoft `System Application` and `Base Application` dependencies required by the BC 16 project.
- No third-party or organization-specific dependencies were present.
- No seed files, fixtures, customer/vendor records, credentials, or other demonstration datasets were found.
- Runtime configuration fields such as statement email, registration fields, number series, and additional text remain user-configurable and contain no embedded organization data.

## Validation

- Confirmed that 28 AL source files and 28 AL object declarations remain.
- Confirmed that all custom object declarations use the `EVK` affix.
- Confirmed that original employer-related affixes, sandbox-role markers, and original custom IDs are absent from source and packaged Word XML.
- Confirmed that `app.json` and `AppSourceCop.json` parse successfully.
- Confirmed that all XLF and RDLC files are valid XML.
- Confirmed that the Word layout is a valid ZIP/XML package.
- Confirmed that AL report layout paths match the renamed RDLC and DOCX files.
- Started compilation with the local AL compiler. Parsing reached dependency resolution, then stopped because the supplied ZIP contains no Business Central 16 `.alpackages` symbols for Microsoft System, System Application, and Base Application.

## Remaining Risks

1. **Rights and licensing:** Neutralization does not establish ownership or permission to publish. Confirm that you have the legal right to publish the source and report layouts. No open-source license was added.
2. **Code fingerprinting:** Business logic, naming patterns, spelling, object structure, captions, and report layout geometry may still resemble the original implementation. Eliminating that risk would require a deeper functional rewrite rather than neutralization.
3. **Historical platform:** The project targets Business Central 16, runtime 5.0. It should be compiled and tested against matching BC 16 symbols before publication, or deliberately upgraded and regression-tested on a newer version.
4. **Generated translations:** XLF unit IDs are generator-produced fingerprints. They contain no direct organization identifier, but regeneration with matching symbols is recommended after the Next() successful build.
5. **Production readiness:** Email, report selection, number series, permissions, registration-field mappings, and localization behavior require environment-specific acceptance testing.

## Intentionally Preserved Portfolio Identity

- Publisher: `EVK Solutions`
- Portfolio profile: `https://github.com/evkanas`
- Personal avatar: `logo.png`

These items identify the portfolio author and were intentionally excluded from employer anonymization.
