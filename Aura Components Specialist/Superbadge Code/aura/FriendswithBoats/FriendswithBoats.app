<aura:application extends="force:slds">
    <lightning:layout>
        <lightning:card title="Find a Boat" class="slds-m-bottom_x-small">
            <c:BoatSearchForm/>
        </lightning:card>
        
        <lightning:card title="Matching Boats">
            <c:BoatSearchResults/>
        </lightning:card>
    </lightning:layout>
</aura:application>