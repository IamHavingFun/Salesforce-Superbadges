public class UpdatePageLayout {
    public Metadata.Layout buildLayout() {
        List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String>{'Account-Account Layout'});
        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
        Metadata.LayoutSection layoutSectionToEdit = null;
        List<Metadata.LayoutSection> layoutSections = layoutMd.layoutSections;
        for (Metadata.LayoutSection section : layoutSections) {
            if (section.label == 'Account Information') {
                layoutSectionToEdit = section;
                break;
            }
        }
        List<Metadata.LayoutColumn> layoutColumns = layoutSectionToEdit.layoutColumns;
        List<Metadata.LayoutItem> layoutItems = layoutColumns.get(0).layoutItems;
        
        Metadata.LayoutItem item = new Metadata.LayoutItem();
        item.behavior = Metadata.UiBehavior.Edit;
        item.field = 'AMAPI__Apex_MD_API_sample_field__c';
        layoutItems.add(item);
        return layoutMd;
    }
}