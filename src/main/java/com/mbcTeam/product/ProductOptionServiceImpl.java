package com.mbcTeam.product;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



@Service
public class ProductOptionServiceImpl implements ProductOptionService {

    @Autowired
    private ProductOptionDao optionDao;

    @Override
    public ProductOptionVO getOptionById(int optionIdx) {
        return optionDao.findById(optionIdx);
    }

    @Override
    public List<ProductOptionVO> getOptionsByProduct(int productIdx) {
        return optionDao.findByProduct(productIdx);
    }

	@Override
	public void insertOption(ProductOptionVO vo) {
		optionDao.insertOption(vo);
		
	}

}
