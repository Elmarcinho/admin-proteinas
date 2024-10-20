import 'package:admin_proteinas/Provider/company.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {

  final CompanyProvider companyProvider;

  CompanyBloc(this.companyProvider) : super(const CompanyState()) {

    on<GetCompanyEvent>( _onGetCompany);
    on<CreateUpdateCompanyEvent>( _onCreateUpdateCompany);
    on<ImageEvent>( _onImageChanged);
  }

  void _onGetCompany( GetCompanyEvent event, Emitter emit) async{
    
    final company = await companyProvider.getCompany();

    emit( 
      state.copyWith(
        image: company,
      )
    );
  }

  void _onCreateUpdateCompany( CreateUpdateCompanyEvent event, Emitter emit) async{

    if(event.isCreate){
        
        emit(
          state.copyWith(
            image: event.qr
          ),
        );
    
    }else{ 
      emit(
        state.copyWith(
          image: event.qr
        )
      );
    }

  }

  void _onImageChanged( ImageEvent event, Emitter emit){
    
    emit(
      state.copyWith(
        image: event.path
      )
    );
  }
}
